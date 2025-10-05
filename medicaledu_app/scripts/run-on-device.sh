#!/usr/bin/env bash
# run-on-device.sh
# Convenience wrapper to run the Flutter app on a target device.
# Usage: ./run-on-device.sh [device-id]
# If no device-id is provided, the script prefers Android (if available), then iOS, then macOS.

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

DEVICE_ID="${1-}"
if [ -n "$DEVICE_ID" ]; then
  echo "Running on specified device: $DEVICE_ID"
  flutter run -d "$DEVICE_ID"
  exit $?
fi

# choose a default device
DEVICE_LIST=$(flutter devices --machine 2>/dev/null || true)

# prefer android
if flutter devices | grep -i android >/dev/null 2>&1; then
  ANDROID_ID=$(flutter devices | awk '/android/{print $1; exit}')
  echo "Running on Android device: $ANDROID_ID"
  flutter run -d "$ANDROID_ID"
  exit $?
fi

# prefer ios
if flutter devices | grep -i ios >/dev/null 2>&1; then
  IOS_ID=$(flutter devices | awk '/ios/{print $1; exit}')
  echo "Running on iOS device: $IOS_ID"
  flutter run -d "$IOS_ID"
  exit $?
fi

# fallback to macos
if flutter devices | grep -i macos >/dev/null 2>&1; then
  echo "No Android/iOS found, running on macOS desktop"
  flutter run -d macos
  exit $?
fi

echo "No supported devices found. Run 'flutter devices' to list available devices."
exit 2
