# Product Vision

## Product Definition

SurgerySimulator is a face-mesh transformation tool, not a generic scanner and not a medical simulator.

Core pipeline:

`Capture -> Representation -> Transformation -> Output`

## Product Goal

Provide a modular iOS foundation for visual facial-change exploration using live TrueDepth capture, repository-owned mesh models, and swappable deformation modules.

## What The Product Should Become

- a reliable mesh-transformation engine
- a testable and replaceable capture stack
- a safe place to iterate on deformation models
- a visual before/after exploration tool with export support

## Non-Goals

- clinical decision support
- anatomical or tissue-level simulation
- claims of surgical accuracy
- coupling the product to a single sensor source forever

## Product Principles

- keep framework-specific code at the edges
- represent facial data in repository-owned models
- prefer deterministic geometry operations over opaque heuristics
- communicate runtime limitations clearly to the user
- preserve a path from prototype to research-grade tooling without forcing premature complexity
