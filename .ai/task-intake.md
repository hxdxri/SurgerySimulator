# Task Intake

Before starting work, answer these questions:

## 1. Which layer owns the change?

- capture
- model
- simulation
- rendering
- UI
- CI or repo process

## 2. Does it cross a boundary?

If yes, make sure only repository-owned models cross that boundary unless the boundary itself is the point of change.

## 3. What proves it works?

- unit test
- simulator launch or smoke validation
- manual physical-device validation
- CI artifact inspection

## 4. What docs must move with it?

- architecture
- product stage
- backlog or milestone
- testing or CI guidance

If the answer is “none,” double-check that assumption.
