#!/usr/bin/env bash
# install-android-sdk.sh
# Download and install Android command-line tools and common SDK components into $HOME/Library/Android/sdk
# WARNING: This script requires internet, can download hundreds of MB, and may need sudo for some operations.

set -euo pipefail

DEST_ROOT="$HOME/Library/Android"
SDK_ROOT="$DEST_ROOT/sdk"
CMDLINE_ROOT="$DEST_ROOT/cmdline-tools"
LATEST_DIR="$CMDLINE_ROOT/latest"

SDK_URL_BASE="https://dl.google.com/android/repository"
OS_TYPE="mac"
ARCH="" # not used here; mac uses darwin

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "This script will download Android command-line tools and install them to: $DEST_ROOT"
read -p "Continue? [y/N] " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted by user." >&2
  exit 1
fi

mkdir -p "$DEST_ROOT"
echo "Downloading command-line tools..."

# Choose package for macOS (darwin)
CMDLINE_ZIP="commandlinetools-mac-9477386_latest.zip"
CMDLINE_URL="$SDK_URL_BASE/$CMDLINE_ZIP"

echo "Downloading $CMDLINE_URL"
cd "$TMP_DIR"
curl -LO "$CMDLINE_URL"

echo "Creating directories..."
mkdir -p "$LATEST_DIR"

echo "Unpacking... (overwriting existing files if present)"
# remove any existing contents to avoid interactive prompts from unzip
rm -rf "$LATEST_DIR"/* || true
unzip -o -q "$CMDLINE_ZIP" -d "$LATEST_DIR"

# The commandline tools usually extract to a folder named 'cmdline-tools'. Move if necessary
if [ -d "$LATEST_DIR/cmdline-tools" ]; then
  # move contents up one directory
  mv "$LATEST_DIR/cmdline-tools"/* "$LATEST_DIR/"
  rmdir "$LATEST_DIR/cmdline-tools" || true
fi

# Create SDK root and ensure sdkmanager exists
mkdir -p "$SDK_ROOT"
export ANDROID_SDK_ROOT="$SDK_ROOT"
export PATH="$LATEST_DIR/bin:$PATH"

echo "Updating SDK manager and installing platform-tools, build-tools, platform-33..."
# Accept licenses non-interactively if possible (sdkmanager supports --sdk_root)
yes | "$LATEST_DIR/bin/sdkmanager" --sdk_root="$SDK_ROOT" --install "platform-tools" "platforms;android-33" "build-tools;33.0.2" || true

# Set up cmdline-tools in expected layout
mkdir -p "$SDK_ROOT/cmdline-tools/latest"
cp -r "$LATEST_DIR"/* "$SDK_ROOT/cmdline-tools/latest/"

# Print final instructions
cat <<EOF
Installation attempted. Please add the following to your shell rc (~/.zshrc):

export ANDROID_SDK_ROOT="$SDK_ROOT"
export PATH="\$ANDROID_SDK_ROOT/platform-tools:\$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:\$PATH"

Then run:

flutter config --android-sdk "$SDK_ROOT"
flutter doctor

If sdkmanager failed due to missing Java, install Java (JDK 11 or later) and re-run the script.
EOF

exit 0
