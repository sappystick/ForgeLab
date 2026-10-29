# Information still needed

1. Output of `scripts/detect_hardware.sh` from the Legion (CPU model, GPU vendor/driver, session type, free disk, data SSD mount path).
2. Is the repo `sappystick/ForgeLab` the right home, and may I use a branch (default proposal: `claude/friendly-faraday-4e5wc6`) rather than `main`?
3. License intent for ForgeLab (personal/closed vs open source). Affects GPL tooling decisions (KiCad, gmsh).
4. Is it acceptable that routing is driven through KiCad (installed separately) rather than embedded natively? (ADR-0005)
5. Which physics matters first (for Slice E): circuit/pulse response, magnetostatic coil fields, or thermal? Related to the ARX pulse-induction detector?
6. Preferred first export formats beyond STL/STEP.
7. Is the ARX repo meant to be a consumer of ForgeLab outputs, or are they independent?
8. Approve ADR-0001..0008 and M0/M1 scope so coding can start.
