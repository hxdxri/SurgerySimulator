# Architecture

## System Model

The app is treated as a pipeline:

`Input -> Representation -> Transformation -> Output`

- Input: TrueDepth face capture through `ARFaceTrackingConfiguration`
- Representation: internal face mesh and frame models
- Transformation: deterministic mesh deformation
- Output: live rendering and mesh export

## Runtime Flow

```text
ARSession
  -> FaceCaptureManager
  -> ARKitFaceMeshAdapter
  -> FaceFrame
  -> FacePipelineController
  -> DeformationPipeline
  -> FaceMesh
  -> MeshRendering
```

## Layers

### Capture

Responsibilities:

- own AR session lifecycle
- receive `ARFaceAnchor`
- convert ARKit geometry into repository-owned models
- publish `FaceFrame` values to a frame consumer

Non-responsibilities:

- no UI logic
- no deformation logic
- no renderer-specific behavior

### Model

Responsibilities:

- define mesh, landmarks, frame, and simulation state
- remain framework-independent where possible

Key types:

- `FaceMesh`
- `FaceLandmarks`
- `FaceFrame`
- `SimulationState`

### Simulation

Responsibilities:

- define pure deformation contracts
- deform a mesh using only internal state and context
- avoid UI, renderer, and ARKit dependencies

Key rules:

- deformations are applied from a fresh base mesh each frame
- deformations depend on `DeformationContext`
- no deformation stores UI state internally

### Rendering

Responsibilities:

- accept internal mesh data and render it
- stay independent of ARKit geometry types

Current implementation:

- `SceneKitFaceMeshRenderer`

### App and UI

Responsibilities:

- host views
- translate control events into `SimulationState`
- assemble concrete components at the composition root
- send state updates to the pipeline

Current composition root:

- `FacePipelineViewController` creates `SceneKitFaceMeshRenderer`
- `FacePipelineViewController` creates `FaceCaptureManager` from the renderer's concrete `ARSession`
- `FacePipelineViewController` injects both into `FacePipelineController`

That keeps `ARSession` out of the pipeline and out of the renderer protocol.

## Key Decisions

### ARKit Is Edge-Only

`ARKitFaceMeshAdapter` is the only type that converts `ARFaceAnchor` into repository models. This keeps future input replacement feasible.

### Simulation State Is Explicit

UI controls write domain state into `SimulationState`. The pipeline reads that state but does not depend on UIKit control types.

### Base Mesh Strategy Prevents Drift

Every frame starts from the newly captured `FaceMesh`. Deformation is applied to a copy of that mesh. This avoids cumulative distortion across frames.

### Renderer Consumes Internal Models

The renderer takes `FaceMesh` plus a transform, not `ARFaceGeometry`.

## Extension Points

- new capture source: conform to `FaceCaptureManaging`
- new deformation: conform to `Deformation`
- new renderer: conform to `MeshRendering`
- new exporter: conform to `FaceMeshExporting`

## Current Risks

- landmarks are heuristic and still noisy
- rendering currently rebuilds geometry every frame
- there is only one production deformation so far
- export exists for `.obj`, but import is still missing
