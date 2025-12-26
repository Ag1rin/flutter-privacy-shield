// lib/privacy_shield.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:local_auth/local_auth.dart';

/// A comprehensive privacy and security widget for Flutter apps.
/// Prevents screenshots, blurs the app in background, requires authentication
/// on resume (if enabled), and optionally blocks rooted/jailbroken devices.
///
/// Features:
/// - Prevent screenshots and screen recording.
/// - Blur the app when in background.
/// - Require biometric/PIN authentication on resume.
/// - Block app on rooted/jailbroken devices.
/// - Customizable max authentication attempts before showing error or exiting.
class PrivacyShield extends StatefulWidget {
  /// The main app widget to protect.
  final Widget child;

  /// Amount of blur applied when app is in background.
  final double blurAmount;

  /// Opacity of the blur overlay.
  final double opacity;

  /// Prevent screenshots and screen recording (default: true).
  final bool preventScreenshot;

  /// Require biometric/PIN authentication when returning from background.
  final bool requireAuthOnResume;

  /// Block the app if device is rooted or jailbroken.
  final bool blockOnJailbreak;

  /// Maximum authentication attempts before showing error (default: 3).
  /// If exceeded, shows a message and optionally exits the app.
  final int maxAuthAttempts;

  /// Custom builder for the compromised device warning screen.
  final Widget? compromisedDeviceBuilder;

  /// Custom builder for the locked screen.
  final Widget Function(BuildContext, SecureApplicationController?)?
  lockedBuilder;

  /// Whether to exit the app after max auth attempts (default: false).
  final bool exitOnMaxAttempts;

  /// Custom message for max attempts exceeded.
  final String maxAttemptsMessage;

  const PrivacyShield({
    super.key,
    required this.child,
    this.blurAmount = 20.0,
    this.opacity = 0.8,
    this.preventScreenshot = true,
    this.requireAuthOnResume = false,
    this.blockOnJailbreak = false,
    this.maxAuthAttempts = 3,
    this.compromisedDeviceBuilder,
    this.lockedBuilder,
    this.exitOnMaxAttempts = false,
    this.maxAttemptsMessage =
        'Too many failed attempts. Please try again later.',
  });

  @override
  State<PrivacyShield> createState() => _PrivacyShieldState();
}

class _PrivacyShieldState extends State<PrivacyShield> {
  final _noScreenshot = NoScreenshot.instance;
  final _localAuth = LocalAuthentication();
  bool _isDeviceCompromised = false;
  late Future<void> _securityFuture;
  int _authAttempts = 0;
  bool _authFailed = false;

  @override
  void initState() {
    super.initState();
    _securityFuture = _setupSecurity();
  }

  Future<void> _setupSecurity() async {
    // Prevent screenshots and screen recording
    if (widget.preventScreenshot) {
      await _noScreenshot.screenshotOff();
    }

    // Detect rooted/jailbroken device
    if (widget.blockOnJailbreak) {
      final bool jailbroken = await FlutterJailbreakDetection.jailbroken;
      bool developerMode = false;
      if (Platform.isAndroid) {
        developerMode = await FlutterJailbreakDetection.developerMode;
      }

      if (jailbroken || developerMode) {
        _isDeviceCompromised = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _securityFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If device is compromised and blocking is enabled, show warning
        if (_isDeviceCompromised) {
          return widget.compromisedDeviceBuilder ??
              Scaffold(
                backgroundColor: Colors.black,
                body: Center(
                  child: Text(
                    'This app cannot run on rooted or jailbroken devices.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 24),
                  ),
                ),
              );
        }

        // If auth failed too many times
        if (_authFailed) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                widget.maxAttemptsMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 24),
              ),
            ),
          );
        }

        return SecureApplication(
          // Require authentication on resume if enabled
          onNeedUnlock: widget.requireAuthOnResume
              ? (controller) async {
                  try {
                    final bool authenticated = await _localAuth.authenticate(
                      localizedReason: 'Please authenticate to access the app',
                      options: const AuthenticationOptions(
                        stickyAuth: true,
                        biometricOnly: false,
                      ),
                    );

                    if (authenticated) {
                      _authAttempts = 0; // Reset attempts
                      controller?.unlock();
                      return SecureApplicationAuthenticationStatus.SUCCESS;
                    } else {
                      _authAttempts++;
                      if (_authAttempts >= widget.maxAuthAttempts) {
                        if (mounted) {
                          setState(() {
                            _authFailed = true;
                          });
                        }
                        if (widget.exitOnMaxAttempts) {
                          // Exit app
                          if (!kIsWeb) {
                            exit(0);
                          }
                        }
                      }
                      return SecureApplicationAuthenticationStatus.FAILED;
                    }
                  } catch (e) {
                    // Handle error (e.g., log it)
                    debugPrint('Authentication error: $e');
                    _authAttempts++;
                    if (_authAttempts >= widget.maxAuthAttempts) {
                      if (mounted) {
                        setState(() {
                          _authFailed = true;
                        });
                      }
                      if (widget.exitOnMaxAttempts) {
                        if (!kIsWeb) {
                          exit(0);
                        }
                      }
                    }
                    return SecureApplicationAuthenticationStatus.FAILED;
                  }
                }
              : null,
          child: SecureGate(
            blurr: widget
                .blurAmount, // Note: parameter is intentionally spelled "blurr" in the package
            opacity: widget.opacity,
            lockedBuilder:
                widget.lockedBuilder ??
                (context, controller) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock, size: 80, color: Colors.white),
                      const SizedBox(height: 20),
                      const Text(
                        'App is locked',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (widget.requireAuthOnResume) {
                            controller?.unlock(); // Triggers onNeedUnlock
                          } else {
                            controller?.unlock();
                          }
                        },
                        child: Text(
                          widget.requireAuthOnResume
                              ? 'Authenticate'
                              : 'Unlock',
                        ),
                      ),
                    ],
                  ),
                ),
            child: widget.child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Re-enable screenshots if needed (optional, depending on app requirements)
    if (widget.preventScreenshot) {
      _noScreenshot.screenshotOn();
    }
    super.dispose();
  }
}
