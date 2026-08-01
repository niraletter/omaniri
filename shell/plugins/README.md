# First-party plugins

These plugins ship with Omaniri and are discovered by the shell at startup.
They use the same `manifest.json` contract as third-party plugins; the
only difference is that the shell flags them with `__isFirstParty: true`.
First-party non-bar plugins are enabled unless listed in `disabledPlugins[]`;
`omaniri.bar` is the default bar option and becomes inactive only while another
`kind: "bar"` plugin is selected. Services and keep-loaded panels are mounted
at startup; other panels, overlays, and menus are loaded on demand.

User-installed plugins live alongside these conceptually but on disk under
`~/.config/omaniri/plugins/<plugin-id>/` rather than in this directory.

| Plugin        | id                        | kinds                   | entry point                           |
|---------------|---------------------------|-------------------------|---------------------------------------|
| Bar           | `omaniri.bar`             | `bar`                   | `bar/Bar.qml`                         |
| Image picker  | `omaniri.image-picker`    | `overlay`               | `image-picker/ImagePicker.qml`        |
| Emojis        | `omaniri.emojis`          | `overlay`               | `emojis/Emojis.qml`                   |
| Clipboard mgr | `omaniri.clipboard`       | `overlay`               | `clipboard/Clipboard.qml`             |
| Reminders     | `omaniri.reminders`       | `overlay`               | `reminders/ReminderFlow.qml`          |
| Omaniri menu  | `omaniri.menu`            | `menu`, `bar-widget`    | `menu/Menu.qml`, `menu/BarWidget.qml` |
| Notifications | `omaniri.notifications`   | `service`               | `notifications/Service.qml`           |
| Audio         | `omaniri.audio`           | `bar-widget`            | `panels/audio/Panel.qml`              |
| Bluetooth     | `omaniri.bluetooth`       | `bar-widget`            | `panels/bluetooth/Panel.qml`          |
| Clock         | `omaniri.clock`           | `bar-widget`            | `panels/clock/BarWidget.qml`          |
| Monitor       | `omaniri.monitor`         | `bar-widget`            | `panels/monitor/Panel.qml`            |
| Network       | `omaniri.network`         | `bar-widget`            | `panels/network/Panel.qml`            |
| Power         | `omaniri.power`           | `bar-widget`            | `panels/power/Panel.qml`              |
| Tailscale     | `omaniri.tailscale`       | `bar-widget`            | `panels/tailscale/Panel.qml`          |
| Agents   | `omaniri.agents`     | `bar-widget`            | `agents/Panel.qml`               |
| Weather       | `omaniri.weather`         | `bar-widget`            | `panels/weather/BarWidget.qml`        |
| Media         | `omaniri.media`           | `service`, `bar-widget` | `services/media/Service.qml`, `services/media/BarWidget.qml` |
| Battery       | `omaniri.battery`         | `service`               | `services/battery/Service.qml`        |
| Idle          | `omaniri.idle`            | `service`               | `services/idle/Service.qml`           |
| Night light   | `omaniri.nightlight`      | `service`               | `services/nightlight/Service.qml`     |
| Lock screen   | `omaniri.lock`            | `service`               | `lock/Service.qml`                    |
| OSD           | `omaniri.osd`             | `panel`                 | `osd/Osd.qml`                         |
| Polkit agent  | `omaniri.polkit`          | `service`               | `polkit/PolkitAgent.qml`              |

First-party bar-only widgets also carry manifests next to their QML files,
e.g. `bar/widgets/Workspaces.manifest.json`. Rich popup widgets live in their
own plugin directories, each with its own `manifest.json`.

## Bar

The built-in status bar and default full-bar option. Layout lives in the
top-level `bar:` subtree of `~/.config/omaniri/shell.json` (with the shell
providing [`config/omaniri/shell.json`](../../config/omaniri/shell.json) when
the user has no file). See [`bar/README.md`](bar/README.md) for the widget catalogue
and customization schema.

## Image picker

Fullscreen image-grid selector overlay. Used by `omaniri-menu-images`
(wallpaper picker) and `omaniri-theme-switcher` (theme picker) and any
other caller that wants to present a directory of images with previews.

Two ways to drive it:

- Shell-level summon: `omaniri-shell shell summon omaniri.image-picker '<jsonPayload>'`.
  The payload can carry `imageDirs`, `imageRows`, `selectedImage`,
  `selectionFile`, `doneFile`, `showLabels`, `filterable`. Best for
  in-shell callers that already speak JSON.
- Direct IPC target: `omaniri-shell image-selector open <imageDirs> <imageRowsB64> <selectedImage> <selectionFile> <doneFile> <showLabels> <filterable>`.
  Positional args; `imageRowsB64` is base64-encoded so embedded newlines /
  tabs survive the bash argv handoff. This is what `omaniri-menu-images`
  uses. Colors come from the central shell theme singleton; there is no
  per-call override surface.

The selection round-trip remains file-based: callers create a
`selection_file` and `done_file` (both `mktemp`), pass the paths, and
poll `done_file` for existence. The plugin writes the chosen path into
`selection_file` and touches `done_file` when it's done. `cancel` IPC
clears it without writing a selection.

The plugin has `keepLoaded: true` so the layer-shell window survives
between summons within a single shell session.

## Lock screen

Session-lock surface using Quickshell's native `WlSessionLock` and two
separate PAM services: `omaniri-lock-password` for password auth and,
only when fingerprints are enrolled, `omaniri-lock-fingerprint` for
fingerprint auth. It mirrors the previous lock screen field dimensions,
colors, blurred wallpaper, placeholder, and Hyprland-driven corners.

## Polkit agent

Theme-aware authentication dialog for privileged actions. It uses
Quickshell's native `Quickshell.Services.Polkit.PolkitAgent` backend and
runs inside the long-lived `omaniri-shell` process, replacing the old
`polkit-gnome-authentication-agent-1` autostart.

## Omaniri menu

Quickshell-powered Omaniri command menu.
The menu UI lives in `menu/Menu.qml` as a first-party `menu` plugin and is
summoned through the shell (`omaniri-shell shell summon omaniri.menu ...`),
so it shares the long-running `omaniri-shell` process instead of starting a
second Quickshell instance.

The menu definition lives outside the shell host code:

- defaults: `default/omaniri/omaniri-menu.jsonc`
- user extensions: `~/.config/omaniri/extensions/omaniri-menu.jsonc`

The shell parses both JSONC files at startup (with `watchChanges: true`
so edits take effect without a restart), evaluates `when:` / `checked:`
bash expressions in a single batched subprocess, and executes the
selected `action:` string directly via `Quickshell.execDetached`. The
long-running shell process keeps the parsed menu in memory, so the
keybind → IPC → visible path costs ~30ms cold.

## Coming soon

- `omaniri.theme-switcher` — folds theme switching into the shell.
