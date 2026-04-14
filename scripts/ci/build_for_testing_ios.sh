#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DERIVED_DATA_ROOT="${RUNNER_TEMP:-/tmp}"

PROJECT="${PROJECT:-$REPO_ROOT/app/ios/TrueDepthStreamer.xcodeproj}"
SCHEME="${SCHEME:-TrueDepthStreamer}"
DERIVED_DATA="${DERIVED_DATA:-$DERIVED_DATA_ROOT/TrueDepthBuild-build-for-testing}"
RESULT_BUNDLE_PATH="${RESULT_BUNDLE_PATH:-$DERIVED_DATA/BuildForTesting.xcresult}"
XCODEBUILD_LOG_PATH="${XCODEBUILD_LOG_PATH:-$DERIVED_DATA/xcodebuild-build-for-testing.log}"

mkdir -p "$DERIVED_DATA" "$(dirname "$RESULT_BUNDLE_PATH")" "$(dirname "$XCODEBUILD_LOG_PATH")"
rm -rf "$RESULT_BUNDLE_PATH"
rm -f "$XCODEBUILD_LOG_PATH"

xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Debug \
  -destination "generic/platform=iOS Simulator" \
  -derivedDataPath "$DERIVED_DATA" \
  -resultBundlePath "$RESULT_BUNDLE_PATH" \
  CODE_SIGNING_ALLOWED=NO \
  build-for-testing 2>&1 | tee "$XCODEBUILD_LOG_PATH"
