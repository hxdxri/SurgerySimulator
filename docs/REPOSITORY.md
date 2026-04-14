# Repository Layout

## Top Level

- `README.md`: repository overview and quick start
- `CONTRIBUTING.md`: contributor workflow and constraints
- `docs/`: architecture, product, planning, quality, ADRs, and reports
- `.ai/`: contributor context, onboarding notes, and repeatable engineering heuristics
- `.github/`: workflows and issue or pull request templates
- `scripts/ci/`: local wrappers used by CI and developers
- `app/ios/`: iOS app source tree and Xcode project
- `CODEOWNERS`, `SECURITY.md`, `SUPPORT.md`: repository hygiene and support policy

## Why The App Lives Under `app/ios/`

The repository started from an Apple sample project. The app was first kept under the sample directory for one pragmatic reason:

- it preserved the existing Xcode project, assets, plist paths, and target wiring while the architecture was being replaced

After the modular pipeline stabilized, the app was moved into `app/ios/` so the repository layout matches its long-term purpose rather than its sample-code origin.

## App Layout

Inside `app/ios/TrueDepthStreamer/`:

- `App/`: programmatic app entry and root view controller
- `Pipeline/`: orchestration only
- `Capture/`: ARKit session and frame adaptation
- `Model/`: repository-owned face representations
- `Simulation/`: pure deformation contracts and state
- `Rendering/`: view rendering from internal models
- `UI/`: controls and view-only composition
- `Export/`: mesh export contracts and implementations
- `PointCloud/`, `Shaders/`, legacy sample files: retained for reference, not part of the active modular pipeline

The composition root currently lives in `App/FacePipelineViewController.swift`, where the concrete renderer and capture manager are wired together and injected into the pipeline controller.

## Boundary Rule

`ARKit` types stop at `Capture/ARKitFaceMeshAdapter.swift`.

Everything downstream uses repository-owned models only:

- `FaceMesh`
- `FaceLandmarks`
- `FaceFrame`
- `SimulationState`
- `DeformationContext`

## Planning And Quality Structure

- `docs/product/`: what the product is, what stage it is in, and where it is headed
- `docs/planning/`: current milestone, backlog, and delivery conventions
- `docs/quality/`: test strategy, device validation, and simulator guidance
- `.ai/`: repo context for day-to-day contributors and onboarding
