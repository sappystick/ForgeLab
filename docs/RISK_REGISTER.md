# Risk register

| # | Risk | L | I | Mitigation | Owner/Gate |
|---|---|---|---|---|---|
| R1 | VTK-in-Qt fails or is slow on Wayland/llvmpipe | M | H | Spike M0-S1; fallback pygfx | M0 |
| R2 | OCP/build123d wheels unavailable for Ubuntu 26.04 default Python | M | H | Pin Python 3.13 in uv venv; spike | M0 |
| R3 | OCCT booleans/fillets fail on exotic geometry (helical grooves) | H | M | Report specific failure, retain inputs, offer mesh path; never auto-repair | M2 |
| R4 | KiCad IPC API incomplete for routing, GUI-only, version churn | H | H | Spike; file-exchange fallback; pin KiCad version; document risk | Slice C |
| R5 | "Full CAD+PCB+library+physics" scope exceeds feasible effort | H | H | Vertical slices, explicit exclusions, no placeholder UI | all |
| R6 | Library data licensing (redistribution) | M | H | Provenance/licence fields, user-supplied libs only, tiny legal sample | Slice D |
| R7 | Solver GPL/licence contamination | M | M | Subprocess isolation, licence review per adapter | Slice E/G |
| R8 | Unverified dependency facts (see options doc) | H | M | Verify before adoption; table tracks status | each ADR |
| R9 | Hardware assumptions wrong (GPU vendor, free disk) | M | M | Run detect script on laptop | M0 |
| R10 | Cloud session cannot test GUI on real GPU | H | M | Headless/offscreen tests here; GUI verification on laptop | all |
| R11 | Data loss on save/crash | L | H | Atomic saves, backups, recovery tests | M1 |
| R12 | Misleading simulation results | M | H | Benchmarks, labelled provenance, "engineering aid" banner | Slice E |
