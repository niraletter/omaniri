# Style

- Two spaces for indentation, no tabs
- Use bash 5 conditionals: use `[[ ]]` for string/file tests and `(( ))` for numeric tests
- In `[[ ]]`, don't quote variables, but do quote string literals when comparing values (e.g., `[[ $branch == "dev" ]]`)
- Prefer `(( ))` over numeric operators inside `[[ ]]` (e.g., `(( count < 50 ))`, not `[[ $count -lt 50 ]]`)
- For strings/paths with spaces, quote them instead of escaping spaces with `\ ` (e.g., `"$APP_DIR/Disk Usage.desktop"`, not `$APP_DIR/Disk\ Usage.desktop`)
- Shebangs must use `#!/bin/bash` consistently (never `#!/usr/bin/env bash`)
- Scripts under `install/` and `migrations/` may be sourced and intentionally omit shebangs

# Command Naming

All commands start with `omaniri-`. Prefixes indicate purpose.

The authoritative command group list lives in `bin/omaniri` in `GROUP_DESCRIPTIONS`. Keep `GROUP_DESCRIPTIONS` updated when adding a new command prefix.

Common prefixes include:

- `cmd-` - check if commands exist, misc utility commands
- `capture-` - screenshots, screen recordings, and other capture tools
- `pkg-` - package management helpers
- `hw-` - hardware detection (return exit codes for use in conditionals)
- `refresh-` - copy default config to user's `~/.config/` or system defaults
- `restart-` - restart a component
- `launch-` - open applications
- `install-` - install optional software
- `setup-` - interactive setup wizards
- `toggle-` - toggle features on/off
- `theme-` - theme management
- `update-` - update components

Other current prefixes include:

- `ac-`, `audio-`, `battery-`, `branch-`, `brightness-`, `channel-`, `config-`, `debug-`, `dev-`, `drive-`, `first-`, `font-`, `haptic-`, `hibernation-`, `hook-`, `hyprland-`, `menu-`, `migrate-`, `niri-`, `notification-`, `npm-`, `plymouth-`, `powerprofiles-`, `reinstall-`, `remove-`, `screensaver-`, `show-`, `snapshot-`, `state-`, `sudo-`, `swayosd-`, `system-`, `transcode-`, `tui-`, `tz-`, `upload-`, `version-`, `voxtype-`, `webapp-`, `wifi-`, `windows-`

# Command Metadata

Commands in `bin/` can declare CLI metadata in comments near the top of the file. `bin/omaniri` scans the first 80 lines, and tests expect command metadata to remain valid.

Supported metadata keys:

- `# omaniri:summary=...` - short help text
- `# omaniri:group=...` - command group when it differs from the filename-derived prefix
- `# omaniri:name=...` - command name within the group
- `# omaniri:args=...` - usage arguments
- `# omaniri:examples=...` - examples separated with ` | `
- `# omaniri:alias=...` / `# omaniri:aliases=...` - alternate routes
- `# omaniri:hidden=true` - hide from default command listings
- `# omaniri:requires-sudo=true` - mark commands that require sudo

Prefer explicit metadata for user-facing commands. Keep routes consistent with the filename unless there is a deliberate alias or compatibility route.

Example:

```bash
# omaniri:summary=Take a screenshot
# omaniri:group=capture
# omaniri:args=[smart|region|windows|fullscreen] [slurp|copy]
# omaniri:examples=omaniri screenshot | omaniri capture screenshot region
# omaniri:aliases=omaniri screenshot
```

# Install Scripts

`install.sh` is the install entry point. It shows the baked-in ASCII banner, sets `OMANIRI_PATH` to `~/.local/share/omaniri`, then sources install stages in order:

1. `install/helpers/all.sh` - logging, errors, presentation
2. `install/preflight/all.sh` - install log UI, first-run marker, temporary mkinitcpio hook disable
3. `install/packaging/all.sh` - packages, icons, TUIs, npm wrappers
4. `install/config/all.sh` - copy configs, themes, system tuning
5. `install/login/all.sh` - keyring, greetd, hibernation
6. `install/post-install/all.sh` - reboot prompt

Leaf scripts are run via `run_logged $OMANIRI_INSTALL/path/to/script.sh` and intentionally omit shebangs. Avoid `exit` in sourced install scripts unless intentionally aborting the install.

Use `$OMANIRI_INSTALL` and `$OMANIRI_PATH` instead of hard-coded omaniri paths. Keep hardware-specific logic under `install/config/hardware/`. Prefer helper commands for package and command checks where available.

Raw `command -v`, `pacman`, and `pacman-key` are acceptable in bootstrap/preflight/package-helper contexts where the helper commands may not be available yet or where direct package-manager behavior is the point of the script.

# Helper Commands

Use these instead of raw shell commands:

- `omaniri-cmd-missing` / `omaniri-cmd-present` - check for commands
- `omaniri-pkg-missing` / `omaniri-pkg-present` - check for packages
- `omaniri-pkg-add` - install packages via pacman when in official repos, otherwise via yay
- `omaniri-pkg-aur-add` - install AUR packages via yay only
- `omaniri-hw-asus-rog` - detect ASUS ROG hardware (and similar `hw-*` commands)

Exceptions are allowed for bootstrap, preflight, migration, and package-helper scripts where the helper may not be available yet, where the helper itself is being implemented, or where direct package-manager behavior is required.

# Config Structure

- `config/` - default configs copied to `~/.config/` during install
- `default/niri/` - stock niri KDL (bindings, autostart, window rules); included from `config/niri/config.kdl`
- `default/greetd/config.toml` - greetd session template (`niri-session`, `@OMANIRI_USER@` substituted at install/refresh)
- `default/themed/*.tpl` - templates with `{{ variable }}` placeholders for theme colors (including `niri.kdl.tpl`)
- `themes/<name>/` - theme assets: `colors.toml`, backgrounds, app-specific theme files (not per-theme `neovim.lua` or `preview-unlock.png`)

Hypr* configs under `config/hypr/` remain for idle, lock, and night light (`hypridle`, `hyprlock`, `hyprsunset`).

# Visual Changes

When making visual changes, such as Waybar styles or desktop appearance, always take and analyze a screenshot after applying the change to verify the result. Use `omaniri capture screenshot fullscreen save` for fullscreen screenshots.

# Refresh Pattern

To copy a default config to user config with automatic backup:

```bash
omaniri-refresh-config niri/bindings.kdl
```

This copies `~/.local/share/omaniri/config/niri/bindings.kdl` to `~/.config/niri/bindings.kdl`.

System greetd config:

```bash
omaniri-refresh-greetd
```


