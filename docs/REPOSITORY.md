# Repository Layout

## Top Level

- `README.md`: repository overview and quick start
- `CONTRIBUTING.md`: contributor workflow and constraints
- `docs/`: architecture, testing, CI, ADRs, and reports
- `.github/`: workflows and issue or pull request templates
- `scripts/ci/`: local wrappers used by CI and developers
- `StreamingDepthDataFromTheTrueDepthCamera/`: iOS app source tree and Xcode project

## Why The App Still Lives Under `StreamingDepthDataFromTheTrueDepthCamera/`

The repository started from an Apple sample project. The app was kept in that directory for one pragmatic reason:

- it preserved the existing Xcode project, assets, plist paths, and target wiring while the architecture was being replaced

That kept churn low while the modular pipeline was established. The directory is now a normal tracked folder in the parent repository, not a git submodule. A future rename to `ios-app/` or `app/ios/` is possible once the project surface is more stable.

## App Layout

Inside `StreamingDepthDataFromTheTrueDepthCamera/TrueDepthStreamer/`:

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
