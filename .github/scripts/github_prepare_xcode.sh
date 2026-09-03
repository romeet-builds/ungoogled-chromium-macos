#!/usr/bin/env bash

set -uo pipefail

echo "Current active Xcode: $(xcode-select -p || true)"
xcodebuild -version || true

AVAILABLE_XCODE=$(ls -d /Applications/Xcode_16*.app /Applications/Xcode*.app 2>/dev/null | sort -V | tail -n 1)

if [ -n "$AVAILABLE_XCODE" ] && [ -d "$AVAILABLE_XCODE" ]; then
  echo "Found Xcode at: $AVAILABLE_XCODE"
  sudo xcode-select --switch "$AVAILABLE_XCODE/Contents/Developer" 2>/dev/null || sudo xcode-select --switch "$AVAILABLE_XCODE" 2>/dev/null || true
fi

echo "Active Xcode developer path: $(xcode-select -p || true)"
exit 0
