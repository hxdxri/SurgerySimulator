# Engineering Playbook

## Architecture Rules

1. Keep `ARKit` isolated to capture.
2. Cross-layer data should use internal models only.
3. Deformations are pure mesh transforms.
4. Renderer consumes `FaceMesh`, never framework-specific geometry.
5. Pipeline coordinates; it should not become business logic.

## Runtime Expectations

- Simulator cannot validate live face tracking.
- Unsupported-state UX on simulator is expected behavior, not a bug.
- Real capture validation requires physical TrueDepth hardware.

## CI Expectations

- `ios-build` and `ios-test` must both pass.
- CI must upload artifacts every run.
- Investigate failures via artifact bundle first, local reproduction second.

## Test Strategy

- Primary: deterministic unit tests around simulation/export/state mapping
- Secondary: simulator smoke checks
- Manual: physical device checklist for live capture path

## Change Management

- Keep PRs scoped by concern.
- Update docs when behavior, architecture, or workflow changes.
- Do not weaken boundaries for short-term convenience.
