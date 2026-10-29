#!/usr/bin/env bash
# Read-only hardware/environment detection for ForgeLab Stage 0. Installs nothing, changes nothing.
# Run on the target laptop:  bash scripts/detect_hardware.sh | tee hardware_report.txt
run() { echo; echo "### $*"; "$@" 2>&1 || echo "(unavailable or failed: $?)"; }
run cat /etc/os-release
run uname -a
run lscpu
run nproc
run free -h
run lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,MODEL,ROTA
run df -hT
run lspci -nnk
run nvidia-smi
run glxinfo -B
run vulkaninfo --summary
run python3 --version
run git --version
run gcc --version
run echo "session=${XDG_SESSION_TYPE:-unknown} desktop=${XDG_CURRENT_DESKTOP:-unknown}"
run which uv kicad kicad-cli gmsh ngspice ElmerSolver ccx freecad openscad
