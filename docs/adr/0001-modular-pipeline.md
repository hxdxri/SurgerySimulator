# ADR 0001: Modular Pipeline Architecture

## Status

Accepted

## Context

The repository started from a camera sample, but the product goal is a swappable face capture and mesh transformation system rather than a scanner demo.

## Decision

Use a layered pipeline:

- Capture
- Model
- Simulation
- Rendering
- UI and orchestration

Only internal models cross boundaries after capture adaptation.

## Consequences

Positive:

- easier to replace capture sources
- easier to test simulation logic
- lower coupling between UI and ARKit

Trade-offs:

- more explicit types and protocols
- more project wiring than a sample-style app
