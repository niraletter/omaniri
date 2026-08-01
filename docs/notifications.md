# Notifications

The shell is the notification daemon: `shell/plugins/notifications/Service.qml`
hosts a Quickshell `NotificationServer` that claims `org.freedesktop.Notifications`
on the session bus. There is no dunst or mako — anything that speaks the
freedesktop notification protocol (notify-send, libnotify apps, Chromium web
apps) lands in the shell, which renders it as a toast card stacked in the
top-right corner. The pure decision logic lives in `NotificationLogic.js`,
which is also loadable from Node so `test/shell.d/` can exercise it without
a compositor.

The end-user view (hotkey notices for time, battery, weather) is in
`manual/10-notices.md`; this document is the system shape behind it.

## Toast lifecycle

A toast lives on screen for at least 5s (low), 8s (normal), or forever
(critical), stretched up to 30s if the sender asked for a longer
`expire_timeout`. Hovering pauses the countdown, and a content update restarts
it — new text deserves a full look. Left-click invokes the default action,
right-click or the hover-revealed close button dismisses.

Every on-screen popup is mirrored to its own file under
`~/.local/state/omaniri/notifications/` (one JSON line per file, named
`<timestamp>-<id>.json`), so live toasts survive the shell restart that
`omaniri-update` performs. When a toast leaves the screen — expiry, dismissal,
or click — its file moves into `notifications/history/`, trimmed to the newest
ten. That directory *is* the history: `showHistory` replays exactly what has
been moved in there. Referenced avatars/images are copied into
`notifications/images/`, because senders delete their originals on close.

`replaces_id` updates never produce a second notification signal: the server
writes new content onto the object the service already holds, so the service
watches the object's property-change signals and rewrites the row and its file
in place, under the popup's original file identity. Restored rows carry ids
from a dead server generation (ids restart from 1 each shell process), so
they are keyed by timestamp+id and never matched against live objects — a
fresh notification reusing an old id must not dismiss or replace them.

## Silencing

Do-not-disturb is a single boolean, persisted as the `dnd` key in
`~/.local/state/omaniri/notifications.json` and toggled via shell IPC
(`omaniri-shell notifications toggleDnd` / `setDnd` / `dndState`).
`omaniri-toggle-notification-silencing` wraps the toggle and refreshes the
bar's `omaniri.indicators` widget, whose Dnd indicator binds directly to the
service's `doNotDisturb` property.

Two kinds of notification punch through DND, chosen to be intentional and
rare:

- `app_name` = `omaniri-action` — Omaniri's own user-action confirmation
  toasts ("Theme changed"). The user just did something; their feedback shows.
- urgency critical *and* `app_name` = `notify-send` — bare-CLI emergency
  alerts. Critical alone is not enough, because chat apps abuse it to force
  visibility; they set `app_name` to their brand, which fails this rule.

A silenced notification that anyone might look back at is written straight
into history — "what did I miss while silenced" is what history is for.
Ephemeral ones (the freedesktop `transient` hint, or an `app_name` of
`notify-send`/`omaniri-action`) are dropped entirely.

## The sender contract

`bin/omaniri-notification-send` is the one way Omaniri code sends
notifications — never raw `notify-send`. It translates its flags into
notify-send arguments and passes any unrecognized options through:

| Flag | Becomes | Meaning |
|---|---|---|
| `-g` / `--glyph` | `--hint=string:omaniri-glyph:` | Nerd Font glyph for the icon slot when no image icon resolves |
| `--exec` | `--hint=string:omaniri-exec:` | shell command the card runs when clicked |
| `--image` | `--hint=string:image-path:` | the standard freedesktop image hint |
| `--app-name` | `-a` | defaults to `omaniri-action` |
| `-u` / `--urgency` | `-u` | defaults to `low` |

The defaults are the point: an unadorned `omaniri-notification-send "Done"`
is a low-urgency user-action toast that pops through DND and is treated as
ephemeral noise when silenced.

`--exec` is deliberately not a libnotify action. An action keeps the sender
blocked waiting for `ActionInvoked`, and dies unanswered whenever the shell
restarts underneath it — the installer toasts restart the shell as their
first act. Carrying the command as a hint means the shell executes the click
itself (detached, so the command outlives the shell process) from the copy it
keeps with the popup, which the persistence files preserve: a restored toast
clicks through exactly like a live one, and oneshot senders can exit
immediately. For third-party clients the click falls back to the libnotify
`default` action while the sender is alive, then to focusing the sender's
window by class via `omaniri-hyprland-focus-app` — chat apps rarely register
an action and just expect click-to-jump.

## Helper commands

- `omaniri-notification-wait [timeout]` — polls until the shell answers IPC
  *and* has claimed the bus name. Anything sending near session start or a
  shell restart uses it, or the toast is sent into the void.
- `omaniri-notification-dismiss <summary>` — dismiss by summary substring,
  used by the first-run toasts once their action has been clicked.
- `omaniri-notification-time` / `-battery` — the hotkey notices: one-line
  low-urgency glyph toasts wrapping `date` and `omaniri-battery-status`.
- `omaniri-notification-weather` — despite the name, not a sender: it toggles
  the `omaniri.weather` shell panel.

Keybindings live in `default/hypr/bindings/utilities.lua`: `Super+comma`
variants map to the IPC methods `dismissOne`, `dismissAll`, `invokeLast`,
`showHistory`, and the silencing toggle.

## How subsystems plug in

Everything goes through the same sender contract, so the pieces are small:

- **Low battery** — `omaniri-battery-low` sends a critical toast and runs the
  `battery-low` hook.
- **Crash capture** — `omaniri-crash-watch` follows the systemd-coredump
  journal stream and announces each crashed program (deduped per minute) as a
  critical toast whose `--exec` runs `omaniri-agent-crash`. It waits for the
  server first: a shell crash takes the notification server down with it, and
  that crash is the one most worth reporting.
- **Pending migrations** — `omaniri-migrate-notify` (from its user service
  after `graphical-session.target`) waits for the server, then sends a
  critical toast whose click opens a terminal running `omaniri-migrate`,
  falling back to printing in the terminal if the hand-off fails.

## Reminders

Reminders ride on notifications rather than being their own daemon.
`bin/omaniri-reminder <minutes> [message]` creates a transient systemd user
timer via `systemd-run --user --collect --on-active=<minutes>m` under the
unit name `omaniri-reminder-<minutes>m-<epoch>`; the timer's payload sends the
reminder toast, deletes its message file, and refreshes the bar indicator.
Custom messages are stashed in `$XDG_RUNTIME_DIR/omaniri-reminders/<unit>.message`
since a unit name cannot carry arbitrary text. `--collect` means fired timers
leave nothing behind.

The state therefore lives entirely in systemd: `show` and `clear` enumerate
`systemctl --user list-timers "omaniri-reminder-*.timer"` — `show` as a
summary toast, `show --json` as the JSON the bar's Reminder indicator polls
(refreshed by the same `omaniri-shell -q omaniri.indicators refresh` call the
timers and mutations make). `omaniri-reminder -i` summons the
`omaniri.reminders` overlay (`shell/plugins/reminders/ReminderFlow.qml`), a
two-step minutes/message prompt that shells back out to `omaniri-reminder` to
do the setting.
