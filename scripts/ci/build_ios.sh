#!/bin/bash
set -euo pipefail

PROJECT="${PROJECT:-StreamingDepthDataFromTheTrueDepthCamera/TrueDepthStreamer.xcodeproj}"
SCHEME="${SCHEME:-TrueDepthStreamer}"
DERIVED_DATA="${DERIVED_DATA:-/tmp/TrueDepthBuild}"

xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Debug \
  -destination "generic/platform=iOS" \
  -derivedDataPath "$DERIVED_DATA" \
  CODE_SIGNING_ALLOWED=NO \
  build
