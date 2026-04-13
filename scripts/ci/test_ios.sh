#!/bin/bash
set -euo pipefail

PROJECT="${PROJECT:-StreamingDepthDataFromTheTrueDepthCamera/TrueDepthStreamer.xcodeproj}"
SCHEME="${SCHEME:-TrueDepthStreamer}"
DERIVED_DATA="${DERIVED_DATA:-/tmp/TrueDepthBuild}"
IOS_SIMULATOR_DESTINATION="${IOS_SIMULATOR_DESTINATION:-platform=iOS Simulator,name=iPhone 16}"

xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Debug \
  -destination "$IOS_SIMULATOR_DESTINATION" \
  -derivedDataPath "$DERIVED_DATA" \
  CODE_SIGNING_ALLOWED=NO \
  test
