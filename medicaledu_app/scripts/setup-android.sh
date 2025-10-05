#!/usr/bin/env bash
# setup-android.sh
# Lightweight helper to assist configuring ANDROID_SDK_ROOT and PATH for the Android SDK.
# This script does NOT install Android Studio. It helps point Flutter to an existing SDK
# or explain how to install the SDK via Android Studio.

set -euo pipefail

echo "Checking for Android SDK and adb..."
if command -v adb >/dev/null 2>&1; then
  echo "adb found at: $(command -v adb)"
  exit 0
fi

# common SDK path
DEFAULT_SDK="$HOME/Library/Android/sdk"

if [ -d "$DEFAULT_SDK" ]; then
  echo "Found SDK at $DEFAULT_SDK"
  echo "To configure your shell, add the following to your ~/.zshrc or ~/.bashrc:"
  echo
  echo "export ANDROID_SDK_ROOT=\"$DEFAULT_SDK\""
  echo "export PATH=\"$ANDROID_SDK_ROOT/platform-tools:$PATH\""
  echo
  echo "Then run: flutter config --android-sdk \"$DEFAULT_SDK\""
  exit 0
fi

cat <<EOF
Android SDK not found in the default location: $DEFAULT_SDK

Recommended next steps:
1) Install Android Studio (https://developer.android.com/studio) and open it.
   Use the SDK Manager (Configure > SDK Manager) to install SDK Platforms and SDK Tools.
2) After install, run this script again or set ANDROID_SDK_ROOT to the installed SDK path.

If you prefer a command-line-only SDK install, download the Command line tools from:
https://developer.android.com/studio#command-tools and follow the manual setup instructions.

EOF

exit 1
