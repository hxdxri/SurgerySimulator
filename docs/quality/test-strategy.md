# Test Strategy

## Testing Layers

### Unit Tests

Primary investment today.

- mesh deformation behavior
- deformation pipeline stability
- export formatting
- unsupported and failed UI state mapping

### Build Verification

Used to validate project wiring even when simulator execution is unavailable.

- `make build`
- `make test-build`

### Simulator Coverage

Used for:

- app launch smoke validation
- unsupported-state UI validation
- deterministic unit tests in CI

Simulator is not considered proof of live capture correctness.

### Manual Device Validation

Used for:

- actual TrueDepth session startup
- live mesh rendering
- deformation behavior against a real face anchor
- interruption and resume behavior

## Artifact Policy

CI should retain enough evidence to debug failures without rerunning immediately:

- `.xcresult` bundles
- raw `xcodebuild` logs
- simulator inventory for test jobs
- Xcode version used for the run

## Current Gaps

- no automated live AR capture coverage
- no visual diff testing for renderer output
- no formal device lab automation
