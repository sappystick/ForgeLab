# Proposed modular architecture

```
UI (PySide6)  ── commands/queries ──>  Document & History (command bus, undo, schema, autosave)
   │                                        │
   │ view-models                            ├─> Geometry service  (kernels: OCCT solid | mesh)
   │                                        ├─> PCB service       (board model, KiCad adapter)
   │                                        ├─> Library service   (SQLite catalog, provenance)
   │                                        ├─> Connectivity      (nets, ratsnest, unit/dimension graph)
   │                                        ├─> Guidance          (event-driven rule checks, no auto-edits)
   └──────────────  Job runner (processes, cancel tokens, limits) ──> Solver adapters
```

## Rules
1. The UI never calls kernels or solvers directly; it sends **Commands** to the Document and renders **Snapshots**.
2. Every state change is a Command with `do/undo`, parameters serializable to JSON. History is the source of truth; geometry is derived and cached.
3. Services are separate Python packages with typed interfaces (Protocols). No service imports the UI.
4. Heavy work (rebuild, boolean, mesh, check, solve) runs in worker **processes** (OCCT is not safely cancellable in threads) with cancel tokens, timeouts and memory limits; the UI thread only receives results.
5. Failure never mutates the document: a command is applied to a copy; only a successful result commits.
6. Guidance and checks are read-only services that emit findings (`severity, source, rule id, confidence, version, limitations`). Nothing edits user data without an explicit command.

## Interfaces (sketch)
- `Document`: `execute(cmd)`, `undo()`, `redo()`, `snapshot()`, `save()`, `dirty`
- `GeometryKernel`: `rebuild(history) -> BodyResult{repr, shape|mesh, report}`, `capabilities() -> {op: Supported|Limited|No}`
- `Representation`: `solid | mesh | curve | surface | invalid-retained`, with per-op capability matrix (ADR-0003)
- `PcbBackend`: `load/save`, `ratsnest`, `check_fast`, `drc_full`, `route_session`
- `Library`: `search`, `get`, `preview_import`, `commit_import`, `rebuild_index`, `backup`
- `SolverAdapter`: `describe`, `validate`, `run(job, cancel)`; every result stores inputs snapshot + versions
- `Checker` (manufacturability, safety, geometric validity, solver validity are separate reports)
