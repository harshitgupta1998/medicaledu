#!/usr/bin/env bash
# accept-android-licenses.sh
# Runs flutter doctor --android-licenses to accept Android SDK licenses.
set -euo pipefail

echo "Running: flutter doctor --android-licenses"
flutter doctor --android-licenses

echo "Done. Re-run 'flutter doctor' to confirm Android toolchain is configured."
