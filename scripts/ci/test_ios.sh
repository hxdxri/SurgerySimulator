#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DERIVED_DATA_ROOT="${RUNNER_TEMP:-/tmp}"

PROJECT="${PROJECT:-$REPO_ROOT/app/ios/TrueDepthStreamer.xcodeproj}"
SCHEME="${SCHEME:-TrueDepthStreamer}"
DERIVED_DATA="${DERIVED_DATA:-$DERIVED_DATA_ROOT/TrueDepthBuild-test}"

if [[ -z "${IOS_SIMULATOR_DESTINATION:-}" ]]; then
  DETECTED_SIMULATOR_UDID="$(
    xcrun simctl list devices available --json \
      | /usr/bin/python3 -c 'import json, sys
data = json.load(sys.stdin)

def first_iphone(booted_only):
    for devices in data.get("devices", {}).values():
        for device in devices:
            if not device.get("isAvailable"):
                continue
            if not device.get("name", "").startswith("iPhone"):
                continue
            if booted_only and device.get("state") != "Booted":
                continue
            return device.get("udid")
    return None

udid = first_iphone(True) or first_iphone(False)
if udid:
    print(udid)'
  )"

  if [[ -n "$DETECTED_SIMULATOR_UDID" ]]; then
    IOS_SIMULATOR_DESTINATION="platform=iOS Simulator,id=$DETECTED_SIMULATOR_UDID"
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
