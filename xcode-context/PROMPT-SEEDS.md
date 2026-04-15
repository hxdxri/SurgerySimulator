# Prompt Seeds For Xcode Intelligence

Use these as starting prompts inside Xcode Intelligence.

## Architecture-safe feature work

`Implement <feature> without violating Capture -> Model -> Simulation -> Rendering boundaries. Keep ARKit isolated to capture and use only FaceMesh/FaceFrame downstream.`

## Deformation work

`Add a new deformation module that conforms to the existing Deformation protocol and DeformationContext usage. Include focused tests for invariants and no-drift behavior.`

## UI behavior work

`Update UI behavior for <state> while preserving unsupported-device guidance and disabled controls semantics when capture is unavailable. Add tests in TrueDepthStreamerTests.`

## CI/debug work

`Modify iOS build/test workflows to keep artifact retention and deterministic resultBundlePath behavior. Do not remove upload-artifact steps.`

## Documentation maintenance

`Update docs/product, docs/planning, docs/quality, and .ai context to reflect this change. Keep current-milestone and backlog aligned.`
