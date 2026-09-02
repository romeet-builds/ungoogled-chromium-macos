#!/usr/bin/env bash

set -euo pipefail
shopt -s extglob

if [ -d "/Applications/Xcode_15.4.app" ]; then
  AVAILABLE_XCODE="/Applications/Xcode_15.4.app"
elif [ -d "/Applications/Xcode_15.3.app" ]; then
  AVAILABLE_XCODE="/Applications/Xcode_15.3.app"
elif [ -n "$(ls -d /Applications/Xcode_15*.app 2>/dev/null)" ]; then
  AVAILABLE_XCODE=$(ls -d /Applications/Xcode_15*.app 2>/dev/null | sort -V | tail -n 1)
else
  AVAILABLE_XCODE=$(ls -d /Applications/Xcode*.app 2>/dev/null | sort -V | tail -n 1)
fi

if [ -n "$AVAILABLE_XCODE" ] && [ -d "$AVAILABLE_XCODE" ]; then
  echo "Found compatible Xcode at: $AVAILABLE_XCODE"
  sudo xcode-select --switch "$AVAILABLE_XCODE/Contents/Developer" || sudo xcode-select --switch "$AVAILABLE_XCODE"
else
  echo "Using default xcode-select: $(xcode-select -p)"
fi

if command -v xcrun &>/dev/null; then
  sudo xcrun simctl delete all 2>/dev/null || true
fi
