import QtQuick
import Quickshell
import Quickshell.Io
import qs.services.niri
import qs.Ui
import qs.Commons
import "KeyboardLayoutModel.js" as KeyboardLayoutModel

// CHANGED FOR NIRI: the original file polled `hyprctl -j devices` on a
// timer/stall-timer/event combo to disambiguate *which physical keyboard on
// the seat* a switch applied to (Hyprland reports layouts per-device,
// including fake "keyboards" for the power button etc. -- see
// KeyboardLayoutModel.js's header comment). niri's IPC has no per-device
// model: `KeyboardLayoutsChanged`/`KeyboardLayoutSwitched` push one global
// layout list + current index for the whole seat via NiriService, so all of
// that polling/disambiguation machinery (queryProc, stallTimer, the 10s
// poll timer, typedKeyboards/selectKeyboard) is gone. This widget is now
// purely reactive to NiriService's properties.

BarWidget {
  id: root
  moduleName: "omaniri.keyboard-layout"

  // Short language code per layout description ("English (US)": "en"), read
  // from xkb's own table rather than maintained by hand. Unchanged from the
  // original -- xkbcli is compositor-agnostic.
  property var layoutBriefs: ({})

  readonly property string layoutFull: {
    const names = NiriService.keyboardLayoutNames
    const idx = NiriService.currentKeyboardLayoutIndex
    return (names && names.length > idx) ? names[idx] : ""
  }
  readonly property string layoutLabel: KeyboardLayoutModel.shortLabel(layoutFull, layoutBriefs)
  // niri always reports the full configured layout list, even with one
  // entry, so gate visibility on there being more than one to switch
  // between (mirrors the original widget's "stay out of the way" intent).
  readonly property bool multipleLayouts: (NiriService.keyboardLayoutNames || []).length > 1

  function cycleLayout() {
    NiriService.cycleKeyboardLayout()
  }

  Component.onCompleted: briefsProc.running = true

  // The table only changes when xkb data is upgraded, so read it at startup
  // and leave it alone. The bar is built per monitor, so this runs once per
  // widget. Unchanged from the original.
  Process {
    id: briefsProc
    command: ["xkbcli", "list", "--load-exotic"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.layoutBriefs = KeyboardLayoutModel.layoutBriefs(text)
    }
  }

  visible: layoutLabel !== "" && multipleLayouts
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.layoutLabel
    fontSize: Style.font.caption
    horizontalMargin: 6
    tooltipText: root.layoutFull
    onPressed: function() { root.cycleLayout() }
  }
}
