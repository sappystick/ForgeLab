# Architecture decision log

All decisions are **Proposed** until the owner approves. Each lists what must be spiked before it becomes Accepted.

## ADR-0001 UI toolkit: PySide6 (LGPL) with a VTK/PyVista viewport
Context: native local app, must run without GPU acceleration, needs picking, sections, scalar-field display later.
Decision: PySide6 6.12.0 + VTK 9.7.1/PyVista 0.49.2 (versions/licences V-PyPI). PyQt6 rejected (GPL-only). Fallback pygfx.
Consequences: Python performance limits; heavy work in worker processes. Verify: Wayland + llvmpipe spike.

## ADR-0002 Native project format: `.forge` ZIP with history-as-source-of-truth
JSON feature history + manifest with sha256 + disposable geometry caches. Versioned schema, migrations. Newer-schema files open read-only.

## ADR-0003 Geometry representations and honesty policy
Representations: `solid` (OCCT B-rep via build123d), `mesh` (trimesh/manifold3d), `curve/surface` (OCCT wires/faces), `invalid-retained` (kept as-is, flagged). Each operation has a capability matrix per representation (Supported / Limited / Unsupported) shown in the UI before and after use. A failed operation reports the kernel message, representation, and offers: keep as mesh, convert representation, run explicit (user-triggered) repair, skip the operation. Nothing is repaired, simplified or dropped silently; original inputs always retained in history. Experimental geometry is allowed; validity, manufacturability and solver-readiness are reported separately.

## ADR-0004 Process model: command bus + worker processes
See ARCHITECTURE.md. OCCT work is isolated in processes so cancel/timeout/memory limits are enforceable.

## ADR-0005 PCB: delegate routing/DRC to KiCad; ForgeLab owns placement UX
Do not write a router. Use KiCad IPC API (kicad-python) and/or file exchange, pinned KiCad version. Import/export dialogs list what may be lost. Status: needs spike; evidence so far is secondary (V-web).

## ADR-0006 Library: SQLite + FTS5, provenance on every record, pint for units
Fields: source, revision/date, licence, redistribution terms, verification status (manufacturer / independently verified / user-entered / estimated / unknown), conditions. Imports are previewed and validated before commit. Ships only a small legal test set.

## ADR-0007 Packaging: pinned Python 3.13 venv (uv or venv) on the data SSD; no snap/flatpak yet
Optional integrations (KiCad, gmsh, solvers) detected at startup and reported as optional.

## ADR-0008 Solvers: adapter registry, analytical first
First benchmarks use numpy/scipy/sympy/pint (analytical). External solvers (gmsh etc.) run as subprocesses behind adapters, each with a validated benchmark and licence review. No "all physics" claims.
