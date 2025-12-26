import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';

class PrivacyShield extends StatelessWidget {
  final Widget child;
  final double blurAmount;
  final double opacity;

  const PrivacyShield({
    super.key,
    required this.child,
    this.blurAmount = 20.0,
    this.opacity = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return SecureApplication(
      child: SecureGate(blurr: blurAmount, opacity: opacity, child: child),
    );
  }
}
