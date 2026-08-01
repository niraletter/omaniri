import QtQuick

// CHANGED FOR NIRI: this file never called into Hyprland's API — it only
// watches `window.screen.x`/`.y` (generic Qt/Quickshell screen geometry),
// working around a Hyprland *behavior* (see below), not a Hyprland *API
// call*. No code change was needed for the niri port. Worth testing whether
// the underlying bug reproduces on niri (its layer-shell implementation is
// a different codebase — Smithay-based, not Hyprland's): if bars/backgrounds
// relocate correctly on output changes without this guard, it's dead weight
// and safe to remove along with its call sites (shell/Ui/qmldir,
// plugins/bar/Bar.qml, plugins/background/Background.qml). If the bug does
// reproduce, leave this exactly as-is.
//
// Hyprland leaves an already-mapped layer surface at its old global position
// when its monitor moves within the layout: undocking disables the internal
// panel, the external monitor shifts to x=0, and long-lived surfaces such as
// the bar and background keep rendering at the old offset — or entirely
// off-screen — until they are unmapped and remapped. Watch the screen's
// origin and pulse `remapping` when it moves; the owning window folds that
// into its `visible` binding so the compositor re-places the surface at the
// monitor's new origin.
Item {
  id: root

  required property var window
  readonly property var screen: window ? window.screen : null

  // Fold into the window's binding: visible: <shown> && !guard.remapping
  property bool remapping: false

  visible: false

  // A layout reshuffle can move the monitor more than once before it lands.
  // Let the positions settle before the single remap pulse.
  Timer {
    id: settleTimer
    interval: 200
    onTriggered: root.remapping = true
  }

  // Hold the surface unmapped for a beat so the compositor processes the
  // unmap before the remap instead of coalescing them into a no-op.
  Timer {
    interval: 50
    running: root.remapping
    onTriggered: root.remapping = false
  }

  Connections {
    target: root.screen
    function onXChanged() { settleTimer.restart() }
    function onYChanged() { settleTimer.restart() }
  }
}
