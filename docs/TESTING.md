# Testing

## Current Strategy

The repository currently emphasizes deterministic tests around pure logic:

- deformation behavior
- deformation pipeline behavior
- export formatting
- unsupported-state UI behavior

This keeps the highest-value tests stable and cheap.

## What Is Covered

- zero-state deformation leaves the mesh unchanged
- local deformation affects only vertices inside its radius
- repeated deformation from the same base mesh does not drift
- `.obj` export writes a usable mesh file
- unsupported and failed capture states produce explicit guidance in the UI layer

## What Is Not Yet Covered

- live AR capture behavior
- visual rendering output
- end-to-end device interaction

Those require device or simulator integration coverage and are intentionally separated from unit tests.

## Commands

Build:

```bash
make build
```

Test:

```bash
make test
```

Compile test targets without executing them:

```bash
make test-build
```

Direct script use:

```bash
./scripts/ci/build_ios.sh
./scripts/ci/build_for_testing_ios.sh
IOS_SIMULATOR_DESTINATION="platform=iOS Simulator,id=<simulator-udid>" ./scripts/ci/test_ios.sh
```

## Test Design Rules

- prefer tests on pure model and simulation code
- avoid snapshotting unstable live geometry
- test invariants, not incidental floating-point details
- use tight but realistic tolerances for vector comparisons

## Simulator-Limited Environments

If CoreSimulator is unavailable on a machine, use `make test-build` to verify the test target still compiles and links. That is not a substitute for running tests on a healthy simulator runner, but it does validate project wiring and test code compilation.

If `IOS_SIMULATOR_DESTINATION` is unset, the test script will try to select a booted iPhone simulator, then the first available iPhone simulator from `simctl`, before falling back to `iPhone 16`.

The simulator is not a face-capture validation environment. Its role is:

- app launch smoke coverage
- unsupported-device guidance validation
- pure logic and UI state regression coverage

The CI scripts also use separate default DerivedData directories so local build and test invocations can run without sharing the same Xcode build database.

See also:

- `docs/quality/test-strategy.md`
- `docs/quality/manual-device-checklist.md`
- `docs/quality/simulator-vs-device.md`
