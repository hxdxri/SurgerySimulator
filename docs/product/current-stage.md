# Current Stage

## Maturity

- prototype
- pre-feature-complete
- architecture-first foundation

## Supported Runtime

- physical iPhone or iPad with a front-facing TrueDepth camera

## Simulator Role

- CI build and test execution
- app launch verification
- unsupported-state UX validation

The simulator is expected to show guidance explaining that live face capture is unavailable there.

## Current Capabilities

- launch into a programmatic pipeline-based app shell
- start TrueDepth face capture on supported hardware
- convert capture data into internal mesh and frame models
- apply one deformation module: nose projection
- render repository-owned mesh data with SceneKit
- export meshes as `.obj`
- build and test through self-hosted CI with retained artifacts

## Known Constraints

- no live face capture in Simulator
- no realistic anatomical simulation
- no persistence or history workflow yet
- no multi-deformation orchestration UI yet
- no production analytics, crash reporting, or release packaging yet

## Current Release Readiness

This repository is suitable for:

- architecture iteration
- pure-logic testing
- device bring-up on supported hardware
- CI hardening and contributor onboarding

This repository is not yet suitable for:

- broad user testing
- clinical demonstrations
- quality claims beyond prototype status
