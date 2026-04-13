#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DERIVED_DATA_ROOT="${RUNNER_TEMP:-/tmp}"

PROJECT="${PROJECT:-$REPO_ROOT/app/ios/TrueDepthStreamer.xcodeproj}"
SCHEME="${SCHEME:-TrueDepthStreamer}"
DERIVED_DATA="${DERIVED_DATA:-$DERIVED_DATA_ROOT/TrueDepthBuild-test}"

if [[ -z "${IOS_SIMULATOR_DESTINATION:-}" ]]; then
  DETECTED_SIMULATOR_NAME="$(
    xcrun simctl list devices available \
      | sed -n 's/^[[:space:]]*\(iPhone[^()]*\) (.*/\1/p' \
      | head -n 1
  )"

  if [[ -n "$DETECTED_SIMULATOR_NAME" ]]; then
    IOS_SIMULATOR_DESTINATION="platform=iOS Simulator,name=$DETECTED_SIMULATOR_NAME"
  else
    IOS_SIMULATOR_DESTINATION="platform=iOS Simulator,name=iPhone 16"
  fi
fi

xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Debug \
  -destination "$IOS_SIMULATOR_DESTINATION" \
  -derivedDataPath "$DERIVED_DATA" \
  CODE_SIGNING_ALLOWED=NO \
  test
