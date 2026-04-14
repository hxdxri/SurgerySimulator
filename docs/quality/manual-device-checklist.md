# Manual Device Checklist

Use a physical iPhone or iPad with a front-facing TrueDepth camera.

## Preflight

- install the latest build
- confirm camera permission is available
- confirm the front-facing TrueDepth camera is unobstructed

## Launch

- app launches without crashing
- unsupported guidance does not appear on supported hardware
- status advances into live tracking

## Capture

- a live face mesh appears
- mesh updates follow head movement
- capture survives brief motion and re-centers cleanly

## Simulation

- moving the nose projection slider updates the rendered mesh
- resetting returns the deformation to neutral
- repeated slider changes do not visibly corrupt the mesh

## Lifecycle

- background and foreground transitions do not leave the app stuck
- interruptions recover or explain failure clearly

## Export

- `.obj` export completes without error
- exported file opens in an external tool if that path is being validated
