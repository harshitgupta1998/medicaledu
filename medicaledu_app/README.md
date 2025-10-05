# medicaledu_app

A starter Flutter application scaffolded with `flutter create`.

Quick start

1. Install Flutter: https://docs.flutter.dev/get-started/install
2. From this directory run:

```bash
flutter pub get
flutter run
```

Targets

- Android (emulator or device)
- iOS (simulator or device)
- Web
- macOS, Windows, Linux (desktop)

Notes

- Flutter SDK version used when creating this project: run `flutter --version` to confirm on your machine.
- Use `flutter analyze` and `flutter test` to run static analysis and tests.

Platform setup notes

Android

- Install Android Studio: https://developer.android.com/studio
- Open Android Studio and install the Android SDK, SDK Platform tools, and an Android emulator image.
- Ensure `adb` and the SDK are on your PATH, or point Flutter to the SDK location:

```bash
# Example: if SDK installed at $HOME/Library/Android/sdk
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export PATH="$ANDROID_SDK_ROOT/platform-tools:$PATH"
flutter config --android-sdk "$ANDROID_SDK_ROOT"
flutter doctor
```

- Accept Android licenses (after Android Studio install):

```bash
flutter doctor --android-licenses
```

iOS

- Xcode (macOS) is required to build for iOS. Install from the App Store and open once.
- CocoaPods is required for plugin dependencies; install/update with:

```bash
sudo gem install cocoapods
pod setup
```

- To run on a connected device or simulator:

```bash
# start iOS simulator from Xcode or run:
open -a Simulator
flutter run -d <device-id>
```

If `flutter doctor` reports missing items, follow the provided links and commands to resolve them.

Helper scripts

I added a few small helper scripts under `scripts/` to simplify local setup and running:

- `scripts/setup-android.sh` — checks for an existing Android SDK and prints shell commands to set `ANDROID_SDK_ROOT` and `PATH`, or points you to install Android Studio.
- `scripts/accept-android-licenses.sh` — runs `flutter doctor --android-licenses` to accept SDK licenses.
- `scripts/run-on-device.sh` — convenience script to run the app on a specified device id or pick a sensible default (Android -> iOS -> macOS).

Make them executable and run like:

```bash
cd medicaledu_app
./scripts/setup-android.sh
./scripts/accept-android-licenses.sh
./scripts/run-on-device.sh # or pass a device id
```

These scripts are intentionally lightweight and do not perform GUI installs like Android Studio; they help wire environment variables and run common commands.

Install Android SDK (CLI)

If you prefer not to install Android Studio, there's an automated helper to download the Android command-line tools and install common SDK components (platform-tools, build-tools, a default platform).

Usage (this will download ~100-300MB and requires Java/JDK installed):

```bash
cd medicaledu_app
./scripts/install-android-sdk.sh
```

After the script finishes, add the exports it prints to your `~/.zshrc`, then run:

```bash
flutter config --android-sdk "$HOME/Library/Android/sdk"
flutter doctor
```

Notes:
- The script attempts to use `sdkmanager` and will require a working JDK (Java). If you don't have Java, install an OpenJDK (11+) first.
- Installing Android Studio remains the recommended approach as it provides an SDK Manager UI and emulators.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
