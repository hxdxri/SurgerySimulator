# ADR 0002: Single Parent Repository

## Status

Accepted

## Context

The parent repository still indexed `StreamingDepthDataFromTheTrueDepthCamera` as a gitlink entry. That prevented the parent repository from tracking normal file changes inside the directory.

## Decision

Remove the stale gitlink entry and track `StreamingDepthDataFromTheTrueDepthCamera/` as a normal directory in the parent repository.

## Consequences

Positive:

- one repository root
- root-level CI and docs work normally
- file changes inside the app directory are tracked directly

Trade-offs:

- parent repository history no longer treats that path as an external submodule boundary
