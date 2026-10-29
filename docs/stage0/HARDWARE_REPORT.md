# Stage 0: Hardware and environment report

## Important: this was NOT inspected on your Legion 5
Stage 0 ran in an Anthropic-hosted cloud container, not on your laptop. The numbers below describe that container and must not be used to size ForgeLab. Run `bash scripts/detect_hardware.sh | tee hardware_report.txt` on the laptop and send the output (or commit it here). Until then the laptop figures are **your stated values, unverified**.

## Detected (cloud container, read-only commands)
| Item | Value | Command |
|---|---|---|
| OS | Ubuntu 24.04.5 LTS (not 26.04) | `cat /etc/os-release` |
| Kernel | 6.18.44 x86_64 | `uname -a` |
| CPU threads | 4 | `nproc` |
| RAM | 15 GiB total | `free -g` |
| GPU | none (`nvidia-smi` not found) | `nvidia-smi` |
| Python | 3.13.17 | `python3 --version` |
| Repo | ForgeLab: 1 commit, README only. ARX (sibling project) is the PHI-FOLD design repo, unrelated code | `git log`, `find` |
| Tools on PATH | kicad, kicad-cli, freecad, gmsh, ngspice, openscad: none found | `which` |
| Outbound network | HTTPS via proxy; PyPI reachable | curl |

## Stated by you, not verified
Lenovo Legion 5, Ubuntu 26.04, 26 GB RAM, 12 threads, 6 GB VRAM GPU (vendor unknown; an image mentions RTX 3060 6GB but images are concept art), 1 TB data SSD, 500 GB OS SSD.

## Not detectable here
CPU model/topology (SMT, P/E cores), GPU vendor/driver/OpenGL/Vulkan versions, session type (X11 vs Wayland), storage layout and free space, mount point for the data SSD, installed toolchain. The script above collects all of these.

## Design consequences already taken
- Do not assume NVIDIA/CUDA. Viewport must run on Mesa llvmpipe (software) and hardware GL.
- Ubuntu 26.04 reportedly defaults to a Wayland-only GNOME session (secondary sources; see options doc). The viewport must be tested on Wayland and XWayland.
- 26 GB RAM / 12 threads gives realistic defaults: background jobs <= 6 workers, UI never blocked, caches default 4 GB, all configurable.
