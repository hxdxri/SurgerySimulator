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

## Environment

The test workflow uses:

- `IOS_SIMULATOR_DESTINATION`

Default:

`platform=iOS Simulator,name=iPhone 16`

Override this through the workflow dispatch input if your local runner uses a different simulator. The local script also falls back to the same default if the environment variable is unset or empty.

## Failure Interpretation

- build failure: broken compile, project wiring, or configuration
- test failure: broken pure logic contract or export behavior
- destination failure: runner simulator configuration mismatch

## Fallback Verification

If a developer machine cannot boot a simulator, `make test-build` can still validate the unit-test target wiring with `build-for-testing`. The GitHub Actions test workflow should still run full `test` on a healthy self-hosted runner.
