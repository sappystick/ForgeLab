# Stage 0: Architecture options and dependency verification

## Verification status legend
- **V-PyPI**: version/license/python range read from the PyPI JSON API on 2026-10-29 from this session.
- **V-web**: from search results (secondary sources), not upstream docs. Re-verify.
- **UNVERIFIED**: from general knowledge; must be checked before the dependency is adopted (spike required).

No dependency below has yet been installed or run on the target laptop. Choices are therefore *proposed*, pending spikes in M0.

## 1. Desktop UI + 3D viewport
| Option | Facts | Fit |
|---|---|---|
| **PySide6 6.12.0** (V-PyPI; LGPL-3.0/GPL; Python >=3.10,<3.16) | Official Qt for Python; LGPL allows closed or MIT app code | Recommended UI toolkit |
| PyQt6 6.12.0 (V-PyPI; GPL-3.0 only) | Commercial license needed for non-GPL distribution | Rejected on license |
| **VTK 9.7.1 (BSD) + PyVista 0.49.2 (MIT)** (V-PyPI) | Mature picking, sections, scalar fields (needed for simulation results). Software rendering via Mesa works; Qt embedding via pyvistaqt (UNVERIFIED version) | Recommended viewport for M1 |
| pygfx 0.17.0 / moderngl 5.13.0 (V-PyPI) | Lighter, modern GPU; weaker picking/CAE visualization; less mature | Fallback if VTK-in-Qt fails the spike |
| Qt Quick 3D | Sleek UI, but CAD picking/sections must be hand-built | Not for M1 |
| Electron/web | Rejected: user asked for a local native app using local hardware | - |
Spike M0-S1: PySide6 + VTK on llvmpipe and on the real GPU, Wayland and XWayland; measure orbit latency with 1M triangles.

## 2. Parametric CAD kernel + mesh/implicit geometry
| Option | Facts | Fit |
|---|---|---|
| **build123d 0.13.0** (V-PyPI; Apache-2.0; Python >=3.11,<3.15) on **cadquery-ocp 8.0.1.1.0** (V-PyPI; Apache-2.0) | Python API over OpenCASCADE B-rep: extrude, revolve, sweep, loft, fillet, chamfer, shell, booleans, STEP/BREP/STL export; helix primitives exist. Which OCCT release the wheel bundles: UNVERIFIED | Recommended solid kernel |
| CadQuery 2.8.0 (V-PyPI; Apache-2.0) | Same kernel, older fluent API | Alternative; build123d chosen for explicit builder/algebra API (preference, confirm in spike) |
| pythonocc-core 0.16 (V-PyPI; LGPL) | Raw OCCT binding, lower level | Not needed |
| **trimesh 5.2.0** (V-PyPI; MIT) + **manifold3d 3.5.4** (V-PyPI; license field empty: UNVERIFIED, upstream believed Apache-2.0) | Mesh I/O, validity checks (watertight, winding), fast robust mesh booleans | Recommended for mesh/experimental path |
| Implicit/SDF | No maintained Python package verified | Deferred; mesh path covers freeform |
| meshio 5.3.5 (V-PyPI; MIT) | Many CAE mesh formats | Solver mesh I/O |
| ezdxf 1.4.5 (V-PyPI) | DXF read/write | Sketch import later |
| shapely 2.2.0 (V-PyPI; BSD) | 2D polygons, validity | Board outlines, sketches |

## 3. Native project format and import/export
- Native `.forge` = ZIP container: `manifest.json` (schema version, app version, units, sha256 of every member), `history.json` (ordered feature list with parameters), `meta.json` (purpose, assumptions, labels), optional cached `*.brep`/`*.stl` blobs, `thumbnail.png`. Rebuildable from history; caches are disposable. Chosen over SQLite-as-document for diff-ability and easy corruption checks. (ADR-0002)
- Verified-in-spike export targets for M1: STL (mesh), STEP (kernel). Import: STEP, STL. Others (3MF, OBJ, glTF, DXF, BREP) are listed only after a round-trip test passes. STEP import yields a *non-parametric* body: history is lost; the UI says so before import.
- Optional: an installed `cadconvert` plugin exists in this environment but failed to start; not relied on.

## 4. PCB design and routing
| Option | Facts | Fit |
|---|---|---|
| **KiCad as backend** (version 10.x per V-web, unconfirmed; license GPL-3.0) | IPC API (needs KiCad >= 9) with official `kicad-python` bindings; per third-party sources: PCB editing only, needs live GUI instance, headless expected later; tracks/vias/zones/nets/commits reported. Native PCB/Gerber/STEP export via `kicad-cli` (UNVERIFIED on 26.04 packaging) | Recommended for Slice C: drive interactive routing, DRC and Gerber through KiCad rather than writing a router |
| Own router in ForgeLab | Months of work, correctness risk | Rejected (charter forbids inventing a router) |
| Freerouting (autorouter) | Java, GPL; UNVERIFIED | Optional, previewable, later |
| File exchange only (.kicad_pcb read/write) | Stable but no live preview | Fallback and for placement slice B |

Honest consequence: truly *embedded* KiCad routing inside the ForgeLab window is not available. Options for Slice C: (a) ForgeLab owns placement/ratsnest/preview, then launches KiCad's router on the same board via IPC with a diff/revert step; (b) ForgeLab implements only walkaround-free manual track entry plus KiCad DRC. Decision deferred to a Slice C spike; asked in OPEN_QUESTIONS.

## 5. Local catalog and search
SQLite (stdlib) with FTS5 for search, plus JSON sidecar for raw source records; schema_version table and ordered migrations; unit-aware values stored as (value, unit, conditions) with `pint 0.26.2` (V-PyPI; BSD-3) for conversion. FTS5 availability in the Ubuntu Python build: UNVERIFIED, test in spike. Rejected: server DBs (offline, simplicity), vector DBs (not needed).

## 6. Meshing and simulation adapters
| Tool | Facts | Fit |
|---|---|---|
| **gmsh 4.15.2** (V-PyPI; GPLv2+) | Mesher with Python API | Use as a separate subprocess so the GPL does not extend to ForgeLab; license review required |
| numpy 2.5.4 / scipy 1.18.1 / sympy 1.14.0 / pint 0.26.2 (V-PyPI; BSD) | Dimensional analysis, workbench, analytical benchmarks | Core of Slice E first benchmarks (analytical, no FEM) |
| Elmer FEM, CalculiX, ngspice, openEMS, MFEM, FEniCS, SU2 | Not installed, not verified | Candidates only. Each needs: license, Ubuntu 26.04 availability, format, and a validated benchmark before adapter work (Slice G) |
Adapter contract: `describe() -> capabilities`, `validate(inputs)`, `run(job, cancel_token) -> result bundle (inputs snapshot, mesh, log, version, convergence)`.

## 7. Packaging and dependency isolation
- Python: Ubuntu 26.04 reportedly ships Python 3.13 default, 3.14 available (V-web, sources conflict). build123d/PySide6 wheel ranges include 3.13 (V-PyPI). **Pin Python 3.13** until wheel availability for 3.14 is verified.
- Use `uv` (UNVERIFIED version/license; check) or stdlib venv with a lockfile and hashes; all environments and caches under a configurable data-SSD path. Never `sudo pip`.
- System packages (kicad, gmsh via apt) are optional integrations detected at startup.
- Distribution (AppImage/deb/snap/flatpak) deferred; not needed for a personal local app. (ADR-0007)
