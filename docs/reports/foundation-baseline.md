# Foundation Baseline Report

## Date

2026-04-12

## Summary

The repository now has a production-oriented foundation rather than a sample-app shape.

## Completed

- removed the stale gitlink boundary from the parent repository index
- established a modular pipeline with clean stage separation
- isolated ARKit to the capture adapter boundary
- introduced explicit simulation state and deformation context
- enforced deformation from a fresh base mesh per frame
- added `.obj` export capability
- added unit-test coverage for core logic
- added self-hosted GitHub Actions workflows and local CI scripts

## Remaining Gaps

- capture landmarks are still heuristic
- rendering reallocates geometry every frame
- there is no mesh import path yet
- there are no integration tests on real hardware

## Recommended Next Steps

1. smooth landmark estimation across frames
2. add a second deformation module
3. reduce renderer allocation churn
4. add hardware validation on a TrueDepth device
