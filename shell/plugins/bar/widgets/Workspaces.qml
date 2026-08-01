import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services.niri
import qs.Commons
import qs.Ui

// CHANGED FOR NIRI: was `import Quickshell.Hyprland` + `Hyprland.workspaces`/
// `Hyprland.focusedWorkspace` (Quickshell's built-in Hyprland module).
// niri has no official Quickshell backend, so this reads NiriService
// instead (see shell/services/niri/NiriService.qml). Also: niri workspaces
// are per-output and dynamic, not a flat global 1-10 like Hyprland's — this
// widget now only shows the workspaces that belong to *this bar's* output,
// which is the more correct niri-native behavior anyway.

BarWidget {
  id: root
  moduleName: "omaniri.workspaces"

  // This bar surface's output. NiriService keys workspaces by niri output
  // name; Quickshell reports the same wl_output name through screen.name.
  // (The reference port read `bar.screenName`, which this shell's Bar does
  // not expose, so resolve it from this widget's own window instead.)
  readonly property string outputName: {
    var window = root.QsWindow.window
    return window && window.screen ? String(window.screen.name || "") : ""
  }

  function currentWorkspaces() {
    return NiriService.workspacesForOutput(root.outputName)
  }

  function focusWorkspace(id) {
    NiriService.focusWorkspace(id)
  }

  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : root.currentWorkspaces().length
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.currentWorkspaces()

      WidgetButton {
        required property var modelData

        readonly property bool occupied: modelData.active_window_id !== undefined
                                          && modelData.active_window_id !== null
        readonly property bool focused: modelData.is_focused === true

        bar: root.bar
        // niri workspaces don't have Hyprland's stable 1-10 numbering; show
        // the compositor's own idx (1-based position on this output).
        text: focused ? "\uDB85\uDCFB" : String((modelData.idx || 0) + 1)
        opacity: occupied || focused ? 1 : 0.5
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData.id) }
      }
    }
  }
}
