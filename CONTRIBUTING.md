# Contributing

## Ground Rules

- Keep `ARKit` isolated to the capture layer.
- Pass only repository-owned models across boundaries.
- Keep deformations pure and deterministic.
- Apply every deformation from the current base mesh, never from a previously deformed mesh.
- Add or update tests when changing model, simulation, export, or pipeline behavior.
- Treat simulator results as launch and unsupported-state validation, not capture validation.
- Keep planning and product docs current when changing scope, delivery assumptions, or runtime support.

## Repository Flow

1. Update docs if you change architecture, CI, or repository structure.
2. Update `docs/planning/current-milestone.md` or `docs/planning/backlog.md` when work changes priority or sequence.
3. Prefer small pull requests with one architectural concern per change.
4. Run `make build` before opening a pull request.
5. Run `make test` when changing pure logic, UI state handling, or export behavior.

## Xcode Project

- Main app project: `app/ios/TrueDepthStreamer.xcodeproj`
- Main scheme: `TrueDepthStreamer`
- Unit tests live under `app/ios/TrueDepthStreamerTests`

## Documentation

- Architecture: `docs/ARCHITECTURE.md`
- Repository layout: `docs/REPOSITORY.md`
- Product vision and roadmap: `docs/product/`
- Planning and milestone tracking: `docs/planning/`
- Testing: `docs/TESTING.md`
- Quality playbooks: `docs/quality/`
- CI: `docs/CI.md`
- Decisions: `docs/adr/`
- Contributor context: `.ai/`
