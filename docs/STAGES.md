# ForgeLab: itemized stage list

Consolidated from the charter, Stage 0/1/2 prompts and the addendum. Status is honest: only Stage 0 is done (documents only). Nothing below Stage 0 is built.

Gate rule: no application code until the owner approves `docs/stage0/` (ADR-0001..0008, milestones, open questions).

## Stage 0: Architecture and inspection (documents only)  [DONE, awaiting approval]
- [x] 0.1 Inspect repo, OS, CPU, RAM, GPU, storage, dev environment (read-only) -> `stage0/HARDWARE_REPORT.md`
- [x] 0.2 Report detected / undetected + commands -> same file; `scripts/detect_hardware.sh` for the real laptop
- [x] 0.3 Compare options (UI/viewport, CAD kernel, format, PCB, catalog, solvers, packaging) -> `stage0/ARCHITECTURE_OPTIONS.md`
- [x] 0.4 Dependency verification table (version, license, python, status of each claim) -> same file
- [x] 0.5 Solids vs meshes vs curves vs invalid geometry policy -> `adr/ADR-0003`
- [x] 0.6 Modular architecture and interfaces -> `stage0/ARCHITECTURE.md`
- [x] 0.7 Staged MVP with exclusions/tests/limits -> `MILESTONES.md`
- [x] 0.8 Reliability measures -> `stage0/RELIABILITY.md`
- [x] 0.9 ADR, risk register, milestones, open questions -> `adr/`, `RISK_REGISTER.md`, `MILESTONES.md`, `OPEN_QUESTIONS.md`

## Stage 1: Application shell + minimal Geometry workflow  [NOT STARTED]
- [ ] 1.1 Window, centered GEOMETRY / DESIGN / SIMULATION nav, active state
- [ ] 1.2 Viewport (software-render capable) + workspace panels
- [ ] 1.3 Project open/save (atomic), units display, undo/redo, object tree, dirty indicator
- [ ] 1.4 Sketch -> profile -> extrude -> edit parameter -> save/reopen -> export one verified format
- [ ] 1.5 Startup report: required vs optional integrations
- [ ] 1.6 Autosave/recovery, failure preservation, off-UI-thread jobs with cancel
- [ ] 1.7 Tests + sample project; report results, memory, limits

## Stage 2 = vertical slice A: Geometry foundation  [NOT STARTED; depends on Stage 1]
- [ ] 2.1 Sketching: line, polyline, rectangle, circle, arc, polygon, dimensions/constraints
- [ ] 2.2 Selection/editing: face/edge/vertex/object, multi-select, gizmo, move/rotate/scale/align/duplicate, numeric input
- [ ] 2.3 Modeling: extrude, cut, revolve, sweep/loft, fillet/chamfer, patterns, booleans, shell, editable history
- [ ] 2.4 Experimental: helix/spiral, grooves, coil former, freeform profile, parametric geometry
- [ ] 2.5 View: pan/zoom/orbit, ortho/persp, section, grid, axes, visibility, display modes
- [ ] 2.6 Import/inspect/export with explicit loss reports
- [ ] 2.7 Limitation reporting (never silent repair), alternatives offered
- [ ] 2.8 Cursor-aware actions with preview/commit/cancel
- [ ] 2.9 Demo: coil former with helical groove + patterned feature; capability matrix of what works

## Slices B-G (from addendum)  [NOT STARTED]
- [ ] B PCB placement, live ratsnest/preview, saved state
- [ ] C Interactive routing via verified backend, rule feedback, undo
- [ ] D Library schema, provenance, import, search, small legal sample set
- [ ] E One end-to-end simulation with benchmark tests
- [ ] F Live guidance (only after deterministic checks + data exist)
- [ ] G Broader solver/library integrations, one testable milestone each
- [ ] X Experimental mode (cross-cutting: labels, separate validity/manufacturability/solver reports, editable assumptions)
- [ ] H Hardware/performance settings (configurable data path, job limits, latency benchmark)

Every stage must ship: feature list + exclusions, acceptance tests + targets, dependency/license check, demo project, known limitations with evidence. No placeholder buttons.
