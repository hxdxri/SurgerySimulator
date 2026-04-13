# Contributing

## Ground Rules

- Keep `ARKit` isolated to the capture layer.
- Pass only repository-owned models across boundaries.
- Keep deformations pure and deterministic.
- Apply every deformation from the current base mesh, never from a previously deformed mesh.
- Add or update tests when changing model, simulation, export, or pipeline behavior.

## Repository Flow

1. Update docs if you change architecture, CI, or repository structure.
2. Prefer small pull requests with one architectural concern per change.
3. Run `make build` before opening a pull request.
4. Run `make test` when changing pure logic or export behavior.

## Xcode Project

- Main app project: `app/ios/TrueDepthStreamer.xcodeproj`
- Main scheme: `TrueDepthStreamer`
- Unit tests live under `app/ios/TrueDepthStreamerTests`

## Documentation

- Architecture: `docs/ARCHITECTURE.md`
- Repository layout: `docs/REPOSITORY.md`
- Testing: `docs/TESTING.md`
- CI: `docs/CI.md`
- Decisions: `docs/adr/`
