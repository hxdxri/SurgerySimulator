# Simulator Vs Device

## Simulator

Use Simulator for:

- build and test automation
- app launch checks
- unsupported-state UX validation
- pure logic and view-state regression coverage

Do not use Simulator for:

- validating live face capture
- validating rendered face mesh behavior from AR data
- validating device camera permissions or hardware performance

## Physical Device

Use a physical TrueDepth-capable iPhone or iPad for:

- AR face tracking validation
- live mesh rendering validation
- deformation behavior against actual capture data
- session interruption and recovery checks

## Expected UX Difference

- Simulator should explain why capture is unavailable.
- Supported hardware should attempt to start capture immediately.
