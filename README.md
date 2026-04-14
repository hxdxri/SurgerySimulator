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
- unsupported-device guidance for simulator and non-TrueDepth environments
- unit-test and self-hosted CI scaffolding with retained `xcresult` artifacts

## Repository Layout

```text
.
|-- README.md
|-- CONTRIBUTING.md
|-- docs/
|-- .github/
|-- scripts/ci/
`-- app/
    `-- ios/
        |-- TrueDepthStreamer.xcodeproj
        `-- TrueDepthStreamer/
```

The app now lives under `app/ios/`. It was initially kept under the sample directory to preserve the existing Xcode project and assets during the architecture rewrite, then moved into a stable application path once the modular pipeline was in place.

## Current Stage

- product maturity: prototype / pre-feature-complete
- supported runtime: physical iPhone or iPad with a front-facing TrueDepth camera
- simulator purpose: CI, launch verification, unsupported-state UX validation
- non-goal: clinical or anatomical accuracy

If you launch the app in Simulator, the renderer remains in an empty state by design. The app now explains that explicitly in the UI because live face tracking is unavailable there.

## Documentation

- Repository: `docs/REPOSITORY.md`
- Architecture: `docs/ARCHITECTURE.md`
- Product vision: `docs/product/vision.md`
- Current stage: `docs/product/current-stage.md`
- Roadmap: `docs/product/roadmap.md`
- Planning: `docs/planning/`
- Testing: `docs/TESTING.md`
- Quality playbooks: `docs/quality/`
- CI: `docs/CI.md`
- Decisions: `docs/adr/`
- Reports: `docs/reports/`
- Contributor context: `.ai/`

## Local Commands

Build:

```bash
make build
```

Test:

```bash
make test
```

Compile tests without executing them:

```bash
make test-build
```

## CI Artifacts

Each CI build and test run now retains:

- the `.xcresult` bundle
- the `xcodebuild` log
- the Xcode version used for the run
- the simulator inventory for test runs

See `docs/CI.md` for how to download and inspect those artifacts from GitHub Actions.
