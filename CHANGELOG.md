## Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- No unreleased changes yet. Add future changes here.

## [0.1.0] - 2025-12-26

### Added
- Initial release of the Flutter Privacy Shield package.
- Core features: Screenshot and screen recording prevention using `no_screenshot`.
- Background blur and app locking with `secure_application`.
- Optional biometric/PIN authentication on app resume via `local_auth`.
- Root/jailbreak detection and blocking using `flutter_jailbreak_detection`.
- Customizable parameters: `blurAmount`, `opacity`, `preventScreenshot`, `requireAuthOnResume`, `blockOnJailbreak`, `maxAuthAttempts`, `exitOnMaxAttempts`, and `maxAttemptsMessage`.
- Custom builders for compromised device screen (`compromisedDeviceBuilder`) and locked screen (`lockedBuilder`).
- Cross-platform support for iOS and Android.
- Error handling for authentication failures, with optional app exit.
- Initial documentation in README.md.

### Fixed
- N/A (initial release).

### Changed
- N/A (initial release).

### Deprecated
- N/A (initial release).

### Removed
- N/A (initial release).

### Security
- Added checks to prevent app from running on compromised devices.
- Implemented authentication attempt limits to mitigate brute-force attacks.