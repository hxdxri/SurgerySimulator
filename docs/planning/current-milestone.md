# Current Milestone: Foundation Hardening

## Objective

Turn the current prototype foundation into a more diagnosable, better documented, and more contributor-friendly base without changing the core pipeline contracts.

## In Scope

- unsupported and failed runtime guidance in the app UI
- CI artifact retention for build and test workflows
- product, planning, quality, and onboarding documentation
- repository hygiene files and contributor guidance

## Out Of Scope

- new capture technologies
- multiple deformation modules in production UI
- persistence and comparison workflows
- realism or anatomical modeling work

## Workstreams

### UX Hardening

- [x] make unsupported environments explicit in the UI
- [x] disable deformation controls when capture cannot run
- [x] cover unsupported and failed UI states with tests

### CI Hardening

- [x] emit deterministic `xcresult` bundles
- [x] retain build and test artifacts on success and failure
- [x] document how to inspect CI artifacts

### Repository Hardening

- [x] add product documentation
- [x] add milestone and backlog structure
- [x] add quality playbooks
- [x] add `.ai/` contributor context
- [x] add root hygiene files

## Exit Criteria

- CI is diagnosable without reproducing every failure locally
- simulator launches communicate runtime limitations clearly
- a new contributor can find product goals, active work, and testing rules quickly
