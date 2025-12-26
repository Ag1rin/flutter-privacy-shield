```markdown
# Flutter Privacy Shield 🚀

A simple yet powerful Flutter package that protects your app's sensitive content by preventing screenshots, blocking screen recording, and blurring the app when it's in the background or app switcher.

## Features

- **Screenshot & Screen Recording Prevention** – Shows black screen on Android when screenshot is taken (using `no_screenshot`).
- **Background Blur** – Securely blurs app preview in recent apps/app switcher (using `secure_application`).
- **Resume Authentication** – Optionally require biometric (Face ID/Touch ID) or PIN authentication when app returns from background.
- **Root/Jailbreak Detection** – Blocks app on compromised (rooted/jailbroken) devices.
- **Highly Customizable** – Max auth attempts, custom locked/compromised screens, and more.
- **Cross-Platform** – Full support for iOS and Android.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_privacy_shield: ^0.1.0
```

Then run:

```bash
flutter pub get
```

### Required Configuration

- **iOS**: Add the following key to your `Info.plist` (for Face ID / Touch ID usage description):
  ```xml
  <key>NSFaceIDUsageDescription</key>
  <string>This app requires biometric authentication to protect your data.</string>
  ```

- **Android**: No additional permissions needed for basic features. Biometric prompts work out of the box.

## Usage

Simply wrap your app (or any widget) with `PrivacyShield`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_privacy_shield/flutter_privacy_shield.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivacyShield(
      preventScreenshot: true,
      requireAuthOnResume: true,
      blockOnJailbreak: true,
      blurAmount: 25.0,
      opacity: 0.9,
      maxAuthAttempts: 3,
      exitOnMaxAttempts: false, // Set to true if you want to force-close app after max failed attempts
      child: MaterialApp(
        title: 'Secure App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Secure Home')),
      body: const Center(
        child: Text('Your sensitive content is now protected! 🔒'),
      ),
    );
  }
}
```

## Customization Options

You can fully customize behavior and UI:

```dart
PrivacyShield(
  preventScreenshot: true,
  requireAuthOnResume: true,
  blockOnJailbreak: true,
  maxAuthAttempts: 5,
  maxAttemptsMessage: 'Too many failed attempts. App locked for security.',
  exitOnMaxAttempts: true,

  // Custom screen when device is rooted/jailbroken
  compromisedDeviceBuilder: const Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Text(
        'This app cannot run on rooted or jailbroken devices.',
        style: TextStyle(color: Colors.red, fontSize: 20),
        textAlign: TextAlign.center,
      ),
    ),
  ),

  // Custom locked screen when authentication is required
  lockedBuilder: (context, controller) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.lock_outline, size: 80, color: Colors.white),
        const SizedBox(height: 20),
        const Text(
          'Authenticate to continue',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => controller?.unlock(),
          child: const Text('Unlock with Biometrics'),
        ),
      ],
    ),
  ),

  child: MaterialApp(...),
);
```

## Development & Testing Tips

- Test **jailbreak/root detection** and **screenshot prevention** only on real devices.
- Ensure the device has biometric authentication (Face ID, Touch ID, fingerprint) or a PIN set for testing `requireAuthOnResume`.
- Some features (like `exitOnMaxAttempts`) are ignored on Flutter Web.

## Contributing

Contributions are welcome! Feel free to:
- Open issues for bugs or feature requests
- Submit pull requests
- Improve documentation

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

Made with ❤️ for secure Flutter apps.
```