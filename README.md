## Note
This document is preliminary and defines the product direction for the first stable framework release.

## Purpose
GraphCreator3D is a Godot framework for creating and editing spatial, multimodal transport networks in 3D.

The framework models transport systems as a generic network abstraction that can be applied to city and non-city domains. It focuses on authoring network topology and spatial geometry on editable terrain, not on detailed simulation of vehicles, agents, or economics.

A network can include multiple transport modalities such as walking, roads, rail, bus, tram, cargo, utilities, and logistics transfer points, while remaining mode-agnostic at the core data model level.

## Product Positioning
- GraphCreator3D is a core framework, not a final domain-specific editor.
- Domain-specific editors (for example road editor, rail editor, utility editor) are expected as extensions built on top of this core.
- The core defines shared topology, geometry, persistence, and validation foundations; extensions add narrowed semantics, richer UX, and richer visualization.

## Scope

### In Scope
- Definition of a generic 3D network format independent from Godot scene object persistence.
- Core entities:
  - Nodes: spatial anchors and connection points.
  - Links: directed or undirected connections with 3D geometry.
  - Areas: polygonal or volumetric regions for walkable, logistics, or pathfinding semantics.
  - Layers: modality or domain separation within one network asset.
  - Connectors: explicit inter-layer transfer links.
- Terrain-aware authoring:
  - Place and edit nodes, links, and areas on terrain.
  - Terrain conformance rules (snap, follow, or manual elevation).
  - Support for terrain-aware structures such as at-grade, bridge-like, and tunnel-like placement flags.
- Editor capabilities:
  - Create, modify, and validate multimodal network assets.
  - Manage multiple layers and inter-layer connectors.
  - Basic visualization primitives suitable for editing and debugging.
- Validation rules:
  - Topology consistency.
  - Layer and connector compatibility.
  - Geometric constraints (for example slope, curvature, minimum spacing) via configurable profiles.
- Extensibility:
  - Mode-specific behavior through data profiles and plugins, not hardcoded transport-specific core classes.
  - Extension editors can add mode-focused tools, constraints, and rendering without changing the core asset model.
- Path-query readiness:
  - Data structures and APIs suitable for downstream multi-agent and goods pathfinding systems.

### Explicit Core vs Extension Boundary
- Core framework responsibilities:
  - Generic data model and asset persistence.
  - Terrain-aware editing foundations.
  - Shared validation engine and base editor primitives.
  - Read-only query interfaces for path consumers.
- Extension editor responsibilities:
  - Mode-specific editing semantics (for example lanes, track classes, pipe classes).
  - Domain-specific visualization and authoring UX.
  - Specialized validation rules that depend on a concrete transport domain.

### Out of Scope (Current Phase)
- High-fidelity graphics and final art pipeline.
- Economic simulation, demand generation, and city-management gameplay loops.
- Detailed simulation of concrete transport entities (vehicle physics, schedules, traffic AI, passenger behavior).
- Final balancing of throughput, pricing, resource flow, or logistics optimization.
- Hardcoding road/rail/utility-specific semantics into the core framework.

### Design Principles
- Core-first abstraction: transport modes are profiles over common graph primitives.
- Spatial correctness: topology and geometry must remain valid on editable terrain.
- Separation of concerns: authoring framework first, gameplay simulation later.
- Reusability: the same core asset model should support different domain-specific editors (road, rail, utility, logistics).
- Backward-compatible extensibility: extension capabilities should not require schema-breaking core rewrites for each new transport domain.

### Extension Contract (Minimum)
- Each extension should integrate through stable core extension points:
  - Profile registration: declare mode-specific constraints and metadata.
  - Tool registration: provide mode-specific editor interactions.
  - Validation hooks: contribute additional domain checks.
  - Rendering adapters: map core entities to extension-specific visuals.
- Extensions must read and write the same core `NetworkAsset` model.
- Extensions may add optional metadata blocks, but must not invalidate core asset loading.

### Non-Goals for Initial Release
- Building a full city-builder game.
- Solving all routing and simulation edge cases.
- Delivering production-level runtime UX.

### Initial Success Criteria
- A user can create a multimodal 3D network with multiple layers and explicit transfers.
- The network is saved and loaded from dedicated framework assets.
- Validation catches broken topology and incompatible layer transitions.
- A downstream system can consume the network for path computation without changing core data structures.

## Version 0.1 Milestone Checklist (Strict)

Release rule: Version 0.1 is complete only if every item below is checked.

### A. Data Model and File Format
- [ ] A `NetworkAsset` root structure exists with `id`, `name`, `version`, `layers`, `nodes`, `links`, `areas`, and `connectors`.
- [ ] Every entity has a stable unique identifier.
- [ ] Layer references are explicit and validated for all layer-bound entities.
- [ ] Link direction is represented (`directed` or `undirected`) in the saved data.
- [ ] File format versioning is implemented with `format_version`.
- [ ] Save and load of the same file is deterministic (no unintended structural changes).

### B. Editor Core Operations
- [ ] Create, move, and delete node operations are implemented.
- [ ] Create, reshape, and delete link operations are implemented.
- [ ] Create and delete layer operations are implemented.
- [ ] Reassigning an entity to another layer is supported where valid.
- [ ] Undo and redo support at least the last 20 operations without corruption.

### C. Terrain-Aware Authoring
- [ ] Node placement supports terrain snap mode.
- [ ] Link control points support terrain follow mode.
- [ ] Manual elevation override is supported for nodes and link control points.
- [ ] Link placement mode flags support at-grade, bridge-like, and tunnel-like semantics.
- [ ] Editing remains stable after terrain height changes (no crashes or broken references).

### D. Multimodal and Layer Semantics
- [ ] Multiple layers can coexist in one network asset.
- [ ] Same-layer links connect only to nodes in the same layer unless a connector is used.
- [ ] Inter-layer connectors are first-class entities with source and destination layer references.
- [ ] Connector validation enforces compatibility rules defined by profiles.

### E. Validation Engine
- [ ] Validator reports orphan links (missing endpoint nodes).
- [ ] Validator reports invalid layer references.
- [ ] Validator reports connector violations.
- [ ] Validator reports geometric constraint violations (at minimum slope and minimum segment length).
- [ ] Validation results include severity (`error`, `warning`) and entity reference.

### F. Visualization and UX Baseline
- [ ] Nodes are rendered with clearly visible point markers.
- [ ] Links are rendered with clearly visible path geometry.
- [ ] Selected entities have distinct highlighting.
- [ ] Layer visibility toggling is implemented.
- [ ] Validation issues are visible in editor UI and can select the affected entity.

### G. API Readiness for Path Consumers
- [ ] Read-only query API returns adjacency for nodes and links.
- [ ] Query API can build a traversable view across selected layers.
- [ ] Query API can include connector edges when requested.
- [ ] Query output is stable enough to be consumed by an external pathfinding module.

### H. Non-Functional Gates
- [ ] All sample assets in `examples/` load without runtime errors.
- [ ] No data-loss bug remains open for save/load operations.
- [ ] No crash-class bug remains open for core editing operations.
- [ ] README documents known limitations for Version 0.1.

### I. Test and Demo Gates
- [ ] At least one automated round-trip test verifies save -> load -> save equivalence rules.
- [ ] At least one automated validator test per rule family (topology, layers, connectors, geometry).
- [ ] At least one integration demo scene shows a multimodal network with at least 3 layers and 2 connectors.
- [ ] Manual test script exists and is reproducible by a second developer.

### J. Exit Criteria
- [ ] All checklist items A-I are complete.
- [ ] Open issues are triaged; all remaining issues are non-blocking and documented.
- [ ] A Version 0.1 release tag is created with release notes and schema version.

## Project Management

For GitHub issue and milestone setup, see [PROJECT_MANAGEMENT.md](PROJECT_MANAGEMENT.md).
