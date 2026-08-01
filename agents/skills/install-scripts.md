# Install Scripts

Read this before working under `install/` or on the system/user setup commands.

The ISO owns installation orchestration. This repo ships target-side setup
commands and reusable setup leaves:

- `bin/omaniri-apply-system` runs root-owned system setup during ISO finalization.
- `bin/omaniri-apply-hardware` runs idempotent hardware-specific setup and is called by `omaniri-apply-system`.
- `bin/omaniri-finalize-user` runs the per-user runtime finalization (skill symlinks, xdg-user-dirs, mime defaults, `install/user/all.sh`). Shipped user defaults are seeded by `/etc/skel` from `omaniri-settings`, not by this command. `bin/omaniri-reinstall-configs` is the explicit destructive resync of those defaults into an existing user's `$HOME`.
- leaf scripts under `install/` are sourced by `run_logged $OMANIRI_INSTALL/path/to/script.sh` and intentionally do not have shebangs.
- avoid `exit` in sourced setup scripts unless intentionally aborting setup.
- use `$OMANIRI_INSTALL` and `$OMANIRI_PATH` instead of hard-coded Omaniri paths.
- keep root-scoped hardware setup under `install/hardware/` and orchestrate it through `install/hardware/all.sh`.
- keep every per-user setup leaf under `install/user/` (including `install/user/hardware/` and `install/user/first-run/`) so it is clear what must run for each user.
- prefer helper commands for package and command checks where available.

Raw `command -v`, `pacman`, and `pacman-key` are acceptable in package-helper
contexts where direct package-manager behavior is the point of the script.
