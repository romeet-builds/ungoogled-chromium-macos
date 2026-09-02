#!/usr/bin/env bash

set -euo pipefail
shopt -s extglob

AVAILABLE_XCODE=$(ls -d /Applications/Xcode_16*.app /Applications/Xcode*.app 2>/dev/null | sort -V | tail -n 1)

if [ -n "$AVAILABLE_XCODE" ] && [ -d "$AVAILABLE_XCODE" ]; then
  echo "Found Xcode at: $AVAILABLE_XCODE"
  sudo xcode-select --switch "$AVAILABLE_XCODE/Contents/Developer" || sudo xcode-select --switch "$AVAILABLE_XCODE"
else
  echo "Using default xcode-select: $(xcode-select -p)"
fi

if command -v xcrun &>/dev/null; then
  sudo xcrun simctl delete all 2>/dev/null || true
fi
