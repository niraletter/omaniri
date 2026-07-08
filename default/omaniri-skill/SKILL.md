---
name: omaniri
description: >
  REQUIRED for end-user customization of Linux desktop, window manager, or system config.
  Use when editing ~/.config/niri/, ~/.config/hypr/, ~/.config/waybar/, ~/.config/walker/,
  ~/.config/alacritty/, ~/.config/foot/, ~/.config/kitty/, ~/.config/ghostty/, ~/.config/mako/,
  or ~/.config/omaniri/. Triggers: Niri, Hyprland idle/lock, window rules, keybindings,
  monitors, gaps, borders, waybar, walker, terminal config, themes, wallpaper, night light,
  idle, lock screen, screenshots, screen recording, reminders, display config, and
  user-facing omaniri commands. Excludes omaniri source development in ~/.local/share/omaniri/
  and `omaniri dev` workflows.
---

# omaniri Skill

Manage [omaniri](https://omaniri.org/) Linux systems — a beautiful, modern, opinionated Arch Linux distribution built on **Niri** (Wayland compositor), with **greetd** for login and Hypr* tools for idle, lock, and night light.

This skill is for end-user customization on installed systems.
It is not for contributing to omaniri source code.

## When This Skill MUST Be Used

**ALWAYS invoke this skill for end-user requests involving ANY of these:**

- Editing ANY file in `~/.config/niri/` (keybindings, monitors, input, window rules, look and feel)
- Editing Hypr* configs in `~/.config/hypr/` (`hypridle`, `hyprlock`, `hyprsunset` — not the main compositor)
- Editing ANY file in `~/.config/waybar/`, `~/.config/walker/`, `~/.config/mako/`
- Editing terminal configs (alacritty, foot, kitty, ghostty)
- Editing ANY file in `~/.config/omaniri/`
- Window behavior, gaps, borders, workspaces, display/monitor configuration
- Themes, wallpapers, fonts, appearance changes
- User-facing `omaniri` commands (`omaniri theme ...`, `omaniri refresh ...`, `omaniri restart ...`, etc.)
- Screenshots, screen recording, reminders, night light, idle behavior, lock screen

**If you're about to edit a config file in ~/.config/ on this system, STOP and use this skill first.**

**Do NOT use this skill for omaniri development tasks** (editing files in `~/.local/share/omaniri/`, creating migrations, or running `omaniri dev ...` workflows).

## Critical Safety Rules

**For end-user customization tasks, NEVER modify anything in `~/.local/share/omaniri/`** — but READING is safe and encouraged.

This directory contains omaniri's source files managed by git. Any changes will be:
- Lost on next `omaniri update`
- Cause conflicts with upstream
- Break the system's update mechanism

```
~/.local/share/omaniri/     # READ-ONLY - NEVER EDIT (reading is OK)
├── bin/                    # Source scripts (symlinked to PATH)
├── config/                 # Default config templates (copied to ~/.config/)
├── themes/                 # Stock themes (colors.toml, backgrounds, app themes)
├── default/                # System defaults (niri KDL, greetd, plymouth, etc.)
├── migrations/             # Update migrations
└── install/                # Installation scripts
```

**Reading `~/.local/share/omaniri/` is SAFE and useful** — do it freely to:
- Understand how omaniri commands work: `omaniri theme set --help` or `cat $(which omaniri-theme-set)`
- See default configs before customizing: `cat ~/.local/share/omaniri/config/niri/config.kdl`
- Check stock theme files to copy for customization: `ls ~/.local/share/omaniri/themes/tokyo-night/`
- Reference default niri settings: `cat ~/.local/share/omaniri/default/niri/bindings/*.kdl`

**Always use these safe locations instead:**
- `~/.config/` — User configuration (safe to edit)
- `~/.config/omaniri/themes/<custom-name>/` — Custom themes (must be real directories)
- `~/.config/omaniri/hooks/` — Custom automation hooks

If the request is to develop omaniri itself, this skill is out of scope. Follow repository `AGENTS.md` instead of this skill.

## System Architecture

| Component | Purpose | Config Location |
|-----------|---------|-----------------|
| **Arch Linux** | Base OS | `/etc/`, `~/.config/` |
| **Niri** | Wayland compositor (session via `niri-session`) | `~/.config/niri/` |
| **greetd** | Display manager (starts `niri-session`) | `/etc/greetd/config.toml` |
| **Waybar** | Status bar | `~/.config/waybar/` |
| **Walker** | App launcher | `~/.config/walker/` |
| **Hypridle / Hyprlock / Hyprsunset** | Idle, lock, night light | `~/.config/hypr/` |
| **Alacritty / Foot / Kitty / Ghostty** | Terminals | `~/.config/<terminal>/` |
| **Mako** | Notifications | `~/.config/mako/` |
| **SwayOSD** | On-screen display | `~/.config/swayosd/` |

Stock niri defaults live under `~/.local/share/omaniri/default/niri/` and are **included** from `~/.config/niri/config.kdl`. User overrides go in `~/.config/niri/*.kdl`.

Themed niri colors come from `~/.config/omaniri/current/theme/niri.kdl` (generated from templates).

## Command Discovery

omaniri ships a single `omaniri` CLI that dispatches to all `omaniri-*` binaries via `omaniri <group> <action>`. Always prefer this form — it is self-documenting and stable.

```bash
omaniri commands
omaniri theme --help
omaniri niri --help
omaniri capture --help
omaniri theme set --help
omaniri commands --json
cat $(which omaniri-theme-set)
```

### Command Groups

| Group | Purpose | Example |
|-------|---------|---------|
| `omaniri refresh` | Reset config to defaults (backs up first) | `omaniri refresh waybar` |
| `omaniri restart` | Restart a service/app | `omaniri restart waybar` |
| `omaniri toggle` | Toggle feature on/off | `omaniri toggle nightlight` |
| `omaniri theme` | Theme management | `omaniri theme set <name>` |
| `omaniri capture` | Screenshots and recordings | `omaniri capture screenshot` |
| `omaniri niri` | Niri monitors, toggles, window layout | `omaniri niri monitor internal` |
| `omaniri install` | Install optional software | `omaniri install docker` |
| `omaniri launch` | Launch apps | `omaniri launch browser` |
| `omaniri reminder` | Desktop notification reminders | `omaniri reminder 15 "Pickup Jack"` |
| `omaniri pkg` | Package management | `omaniri pkg add <pkg>` |
| `omaniri update` | System updates | `omaniri update` |

## Configuration Locations

### Niri (Compositor)

```
~/.config/niri/
├── config.kdl           # Main config (includes defaults + local files)
├── bindings.kdl         # User keybindings
├── monitors.kdl         # Outputs
├── input.kdl            # Keyboard, touchpad, mouse
├── looknfeel.kdl        # Borders, colors (often includes themed niri.kdl)
└── windowrules.kdl      # Window rules
```

Defaults (do not edit in place — override in `~/.config/niri/` or refresh from stock):

```
~/.local/share/omaniri/default/niri/
├── autostart.kdl
├── windows.kdl
├── bindings.kdl          # Include manifest
└── bindings/*.kdl        # utilities, media, clipboard, tiling, etc.
```

**Key behaviors:**
- Reload after changes: `niri msg action load-config-file` (or restart the session)
- Validate: check `journalctl --user -u niri` or run config through niri's error output
- Reset a file: `omaniri refresh config niri/bindings.kdl`
- Keybinding reference: `omaniri menu keybindings --print`

**KDL binding example** (in `bindings.kdl` or a sourced fragment):

```kdl
binds {
  Mod+Return hotkey-overlay-title="Terminal" { spawn "foot"; }
}
```

### Hypr* (Idle, lock, night light only)

```
~/.config/hypr/
├── hypridle.conf      # Idle behavior (screen off, lock, suspend)
├── hyprlock.conf      # Lock screen appearance
└── hyprsunset.conf    # Night light
```

Refresh: `omaniri refresh hypridle`, `omaniri refresh hyprlock`

### Waybar (Status Bar)

```
~/.config/waybar/
├── config.jsonc
└── style.css
```

**Waybar does NOT auto-reload.** Run `omaniri restart waybar` after changes.

### Terminals

```
~/.config/alacritty/alacritty.toml
~/.config/foot/foot.ini
~/.config/kitty/kitty.conf
~/.config/ghostty/config
```

**Command:** `omaniri restart terminal`

## Safe Customization Patterns

### Pattern 1: Edit User Config Directly

```bash
cat ~/.config/niri/bindings.kdl
cp ~/.config/niri/bindings.kdl ~/.config/niri/bindings.kdl.bak.$(date +%s)
# Edit, then reload niri config or log out/in
```

- **Niri:** reload config after edits
- **Waybar:** `omaniri restart waybar`
- **Walker:** `omaniri restart walker`
- **Terminals:** `omaniri restart terminal`

### Pattern 2: Make a New Theme

1. Create `~/.config/omaniri/themes/<name>/` (real directory).
2. Copy structure from a stock theme: `~/.local/share/omaniri/themes/tokyo-night/` (`colors.toml`, `backgrounds/`, etc.).
3. Stock themes use `colors.toml` and per-app theme files — not `neovim.lua` or `preview-unlock.png`.
4. Apply: `omaniri theme set "Name of new theme"`

### Pattern 3: Hooks

```bash
~/.config/omaniri/hooks/
├── theme-set        # After theme change ($1 = theme name)
├── font-set
└── post-update      # After `omaniri update`
```

### Pattern 4: Reset to Defaults — CONFIRM WITH USER FIRST

```bash
omaniri refresh waybar
omaniri refresh config niri/bindings.kdl
omaniri refresh hyprlock
```

`omaniri refresh config <path>` copies from `~/.local/share/omaniri/config/<path>` to `~/.config/<path>` with a timestamped backup.

## Common Tasks

### Themes

```bash
omaniri theme list
omaniri theme current
omaniri theme set <name>        # Display name, e.g. "Tokyo Night"
omaniri theme bg next
omaniri theme install <url>
```

### Keybindings

Edit `~/.config/niri/bindings.kdl` or add includes under `~/.config/niri/`. Defaults are in `default/niri/bindings/*.kdl`.

View bindings: `omaniri menu keybindings --print`

When rebinding, check for conflicts in that output first.

### Display / Monitors

Edit `~/.config/niri/monitors.kdl`. List outputs: `niri msg outputs` (or use `omaniri niri` monitor helpers).

### Capture

```bash
omaniri capture screenshot              # region (grim + slurp)
omaniri capture screenshot fullscreen
omaniri capture screenrecording         # default: slurp + gpu-screen-recorder
omaniri-menu screenrecord               # menu: portal/slurp variants
omaniri capture text-extraction         # OCR region
```

### Fonts

```bash
omaniri font list
omaniri font current
omaniri font set <name>
```

### System

```bash
omaniri update
omaniri version
omaniri debug --no-sudo --print   # ALWAYS use these flags
omaniri system lock
omaniri system shutdown
omaniri system reboot
```

### Login (greetd)

Installed config: `/etc/greetd/config.toml` — runs `niri-session` as the installing user.

Refresh from stock: `omaniri-refresh-greetd` (requires sudo).

## Troubleshooting

```bash
omaniri debug --no-sudo --print
omaniri upload log
omaniri refresh <component>
omaniri refresh config niri/config.kdl
omaniri reinstall
```

## Decision Framework

1. **Stock omaniri command?** Use it.
2. **Config edit?** Edit `~/.config/`, never `~/.local/share/omaniri/`.
3. **Theme tweak?** Custom theme under `~/.config/omaniri/themes/`.
4. **Automation?** Hooks in `~/.config/omaniri/hooks/`.
5. **Packages?** `omaniri pkg add` (official repos) or `omaniri pkg aur add` (AUR).
6. **Unsure?** `omaniri commands` or `omaniri <group> --help`.

### Reminders

```bash
omaniri reminder 15 "Pickup Jack"
omaniri reminder show
omaniri reminder clear
```

## Out of Scope

- Editing `~/.local/share/omaniri/` source (`bin/`, `install/`, `migrations/`, etc.)
- Migrations and `omaniri dev ...`
- See repo `AGENTS.md` for development conventions

## Example Requests

- "Change my theme to catppuccin" → `omaniri theme set catppuccin`
- "Bind Super+E to file manager" → Edit `~/.config/niri/bindings.kdl`, check `omaniri menu keybindings --print`
- "Configure my external monitor" → Edit `~/.config/niri/monitors.kdl`
- "Smaller window gaps" → Niri look/feel or `omaniri niri` gap toggles if enabled
- "Night light at sunset" → `omaniri toggle nightlight` or `~/.config/hypr/hyprsunset.conf`
- "Screenshot full screen" → `omaniri capture screenshot fullscreen`
- "Record screen with mic" → `omaniri menu screenrecord` or capture commands with portal flags
- "Reset waybar" → `omaniri refresh waybar`
