# SurgerySimulator

SurgerySimulator is an iOS face-mesh transformation app built as a modular pipeline rather than a monolithic camera demo.

`Input -> Representation -> Transformation -> Output`

## Repository Goals

- isolate `ARKit` to the capture edge
- keep simulation deterministic and testable
- render from repository-owned models, not framework geometry
- support future swap-outs for capture, deformation, rendering, and export

## Current Foundation

- live TrueDepth face capture through `ARFaceTrackingConfiguration`
- internal mesh and frame models
- explicit simulation state and deformation context
- one production deformation module: nose projection
- SceneKit renderer that consumes `FaceMesh`
- `.obj` export foundation
- unit-test and self-hosted CI scaffolding

## Repository Layout

```text
.
|-- README.md
|-- CONTRIBUTING.md
|-- docs/
|-- .github/
|-- scripts/ci/
`-- StreamingDepthDataFromTheTrueDepthCamera/
    |-- TrueDepthStreamer.xcodeproj
    `-- TrueDepthStreamer/
```

The app stays under `StreamingDepthDataFromTheTrueDepthCamera/` because that preserved the existing Xcode project and sample assets while the architecture was replaced. It is now tracked as a normal directory in the parent repository, not as a submodule.

## Documentation

- Repository: `docs/REPOSITORY.md`
- Architecture: `docs/ARCHITECTURE.md`
- Testing: `docs/TESTING.md`
- CI: `docs/CI.md`
- Decisions: `docs/adr/`
- Reports: `docs/reports/`

## Local Commands

Build:

```bash
make build
```

Test:

```bash
make test
```
