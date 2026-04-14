# Testing Methodology

## Default Bias

Write tests closest to pure logic first.

## Good Candidates For Tests

- deformation invariants
- pipeline drift prevention
- export formatting
- UI state changes driven by typed capture outcomes

## Poor Candidates For Early Tests

- live AR session internals
- visually fragile renderer snapshots
- simulator-based assumptions about real hardware capture

## CI Relationship

- CI proves the project builds
- CI proves the unit and UI-state tests run on the self-hosted runner
- CI artifacts should be enough to inspect failures without guessing

## Manual Validation Still Required

- TrueDepth session startup
- live face mesh rendering
- physical-device interruption handling
