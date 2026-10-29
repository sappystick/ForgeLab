# Milestone plan

Performance targets are **proposed**, to be re-measured on the Legion.

| M | Slice | Features | Exclusions | Acceptance | Target |
|---|---|---|---|---|---|
| M0 | Spikes (no product code) | Detect hardware; PySide6+VTK on llvmpipe/GPU; build123d on Py3.13; STEP/STL round trip; SQLite FTS5; KiCad IPC probe | Any UI features | Each spike has a written pass/fail note | - |
| M1 | Shell + minimal geometry (Stage 1) | Nav, viewport, atomic save, undo/redo, object tree, sketch->extrude->param edit->save->export STL/STEP, startup report | PCB, library, sim, constraints solver | Tests: create, params, save/reopen, export, undo, interrupted save, failure preservation, recovery | Startup < 3 s; orbit >= 30 fps at 500k tris on GPU, >= 10 fps on llvmpipe |
| M2 | A: Geometry foundation (Stage 2) | Sketch tools + dimensions, selection/transform, revolve/sweep/loft/fillet/chamfer/patterns/booleans/shell as kernel supports, helix/groove/coil former, section view, import with loss report | Full constraint solver beyond simple dimensions unless a library is verified | Regression geometry tests (volume/bbox), coil former demo, capability matrix | Rebuild of demo < 5 s |
| M3 | B: PCB placement | Place/drag/rotate/flip, snap, courtyards, ratsnest preview, 2D/3D sync | Routing | Connection correctness, save/reopen | Drag preview < 16 ms/frame at 200 parts |
| M4 | C: Routing | Per spike outcome (KiCad IPC or file exchange) | Autorouter claims, diff-pair/length tuning unless backend verified | Route preview, DRC, undo, import/export loss report | - |
| M5 | D: Library | Schema, migrations, provenance, import preview, FTS search, legal sample | Bulk scraping, "complete library" claims | Migration/malformed/duplicate/units/licence/backup/offline tests | Search < 50 ms at 100k rows (to verify) |
| M6 | E: One simulation | Analytical + one verified FEM or circuit benchmark | Multiphysics | Matches reference case within stated tolerance | Memory warning above configured limit |
| M7 | F: Guidance | Deterministic checks -> explainable suggestions, debounced | AI features unless optional/offline-safe | Never edits without command | Idle CPU < 5% |
| M8+ | G: Broader solvers/libraries | One per milestone | - | Benchmark per adapter | - |

Experimental mode (labels, separate validity reports, editable assumptions) is introduced at M1 as metadata and grows each milestone.
