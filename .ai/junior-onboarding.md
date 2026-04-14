# Junior Onboarding

## Start Here

1. Read `README.md`.
2. Read `docs/ARCHITECTURE.md`.
3. Read `docs/product/current-stage.md`.
4. Read `docs/planning/current-milestone.md`.
5. Read `docs/quality/test-strategy.md`.

## Mental Model

- capture gets data
- model owns the data shape
- simulation changes the mesh
- rendering displays repository-owned mesh data

If you find `ARFaceAnchor` or renderer-specific code leaking into simulation code, stop and fix the boundary.

## First Commands

```bash
make build
make test-build
make test
```

## Common Mistakes To Avoid

- testing live capture in Simulator and assuming black output is a rendering bug
- adding framework-specific types to model or simulation layers
- mutating already-deformed mesh data frame after frame
- changing architecture without updating docs

## When You Are Unsure

- check `docs/planning/backlog.md` for whether the work is already staged
- check `.ai/task-intake.md` before starting a new implementation
- prefer small, testable changes over wide refactors
