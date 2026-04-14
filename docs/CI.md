# CI

## Workflows

- `.github/workflows/ios-build.yml`: builds the iOS app on a self-hosted macOS runner
- `.github/workflows/ios-test.yml`: runs unit tests on a self-hosted macOS runner with an available iOS simulator

## Runner Requirements

Recommended runner labels:

- `self-hosted`
- `macOS`
- `Xcode`

Required tools:

- Xcode with iOS SDK installed
- at least one bootable iOS simulator runtime for test execution

## Local Scripts

The workflows call repository scripts instead of embedding long `xcodebuild` commands:

- `scripts/ci/build_ios.sh`
- `scripts/ci/build_for_testing_ios.sh`
- `scripts/ci/test_ios.sh`

That keeps local and CI behavior aligned.

Each script uses its own default DerivedData directory under `RUNNER_TEMP` or `/tmp` so build and test jobs do not contend for the same Xcode build database.

Each script also accepts:

- `RESULT_BUNDLE_PATH`
- `XCODEBUILD_LOG_PATH`

The workflows set those explicitly so artifact paths stay predictable.

## Environment

The test workflow uses:

- `IOS_SIMULATOR_DESTINATION`

The workflow dispatch input is an optional override only. If the environment variable is unset or empty, the local test script first attempts to pick a booted iPhone simulator from `simctl`, then the first available iPhone UDID, and only then falls back to `iPhone 16` by name.

## Failure Interpretation

- build failure: broken compile, project wiring, or configuration
- test failure: broken pure logic contract or export behavior
- destination failure: runner simulator configuration mismatch

## Artifacts

The workflows now retain artifacts on both success and failure.

Build workflow:

- `build.xcresult`
- `xcodebuild-build.log`
- `xcode-version.txt`

Test workflow:

- `test.xcresult`
- `xcodebuild-test.log`
- `available-simulators.txt`
- `xcode-version.txt`

### How To Inspect Artifacts

1. Open the relevant GitHub Actions run.
2. Scroll to the `Artifacts` section near the run summary.
3. Download the `ios-build-artifacts` or `ios-test-artifacts` archive.
4. Unzip it locally.
5. Open the `.xcresult` bundle in Xcode:

```bash
open build.xcresult
open test.xcresult
```

The `.xcresult` bundle contains the structured build or test report; the `.log` file is the raw console output that the runner streamed during the job.

## Fallback Verification

If a developer machine cannot boot a simulator, `make test-build` can still validate the unit-test target wiring with `build-for-testing`. The GitHub Actions test workflow should still run full `test` on a healthy self-hosted runner.
