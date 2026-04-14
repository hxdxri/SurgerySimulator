# Repository Context

## What This Repository Is

An iOS modular face-mesh transformation prototype with a pipeline architecture:

`Capture -> Model -> Simulation -> Rendering`

## Critical Boundary Rules

- `ARKit` knowledge stops in `Capture/`
- downstream code consumes repository-owned models only
- deformations operate on mesh data, not UI or renderer state
- pipeline orchestration coordinates; it should not become the place where deformation logic lives

## Key Paths

- app entry: `app/ios/TrueDepthStreamer/App/`
- capture: `app/ios/TrueDepthStreamer/Capture/`
- models: `app/ios/TrueDepthStreamer/Model/`
- simulation: `app/ios/TrueDepthStreamer/Simulation/`
- rendering: `app/ios/TrueDepthStreamer/Rendering/`
- UI: `app/ios/TrueDepthStreamer/UI/`
- tests: `app/ios/TrueDepthStreamerTests/`
- CI scripts: `scripts/ci/`

## Current Runtime Truth

- live capture requires physical TrueDepth hardware
- simulator exists for CI and unsupported-state validation
- the app is a prototype, not a medical simulator
