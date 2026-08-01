pragma Singleton
import Quickshell
import Quickshell.Io

// NiriService — replaces `import Quickshell.Hyprland` for Omaniri's niri port.
//
// Quickshell has no official niri backend. This is a deliberately small IPC
// layer covering exactly what Omaniri's shell needs: workspaces, windows,
// outputs, keyboard layouts, and the handful of actions the ported
// widgets/services call. It follows the same event-stream +
// one-shot-socket pattern as DankMaterialShell's NiriService.qml, trimmed of
// everything DMS-specific (matugen theming, blur-rule/hotcorner/config-file
// generation, screencast/"cast" UI, xray). If you need more later, those are
// the fields/actions to add — see niri's IPC docs:
// https://github.com/niri-wm/niri/wiki/IPC
//
// Real niri JSON field names below (workspace.id/idx/output/is_focused/
// is_active/active_window_id, window.id/app_id/title/workspace_id/
// is_focused, output.logical.{x,y,scale}, keyboard_layouts.{names,
// current_idx}) were confirmed against DankMaterialShell's implementation,
// not guessed.

Singleton {
  id: root

  readonly property string socketPath: Quickshell.env("NIRI_SOCKET")
  readonly property bool available: socketPath !== undefined && socketPath !== ""

  // id -> workspace object (as sent by niri)
  property var workspaces: ({})
  property var allWorkspaces: []
  property string focusedWorkspaceId: ""
  property string currentOutput: ""

  // flat array of window objects
  property var windows: []

  // output name -> output object (from `niri msg -j outputs`)
  property var outputs: ({})

  property var keyboardLayoutNames: []
  property int currentKeyboardLayoutIndex: 0

  property bool connected: false

  signal windowFocusChanged(var windowId)
  signal windowOpened(var window)
  signal windowClosed(var windowId)

  function _refreshAllWorkspaces() {
    allWorkspaces = Object.values(workspaces).sort(function (a, b) {
      return (a.idx || 0) - (b.idx || 0)
    })
  }

  function _setWorkspaces(map) {
    workspaces = map
    _refreshAllWorkspaces()
  }

  // --- one-shot outputs fetch (event stream doesn't push full output
  // geometry on startup, matching DMS's own comment on why they fetch
  // this separately rather than relying purely on OutputsChanged) ---
  Process {
    id: outputsFetch
    command: ["niri", "msg", "-j", "outputs"]
    stdout: StdioCollector {
      onStreamFinished: {
        try {
          root.outputs = JSON.parse(text)
        } catch (e) {
          console.warn("NiriService: failed to parse outputs:", e)
        }
      }
    }
  }
  function fetchOutputs() { outputsFetch.running = true }

  // --- persistent event-stream connection ---
  Socket {
    id: eventStream
    path: root.socketPath
    connected: root.available

    onConnectedChanged: {
      if (connected) {
        write('"EventStream"\n')
        root.connected = true
        root.fetchOutputs()
      } else {
        root.connected = false
      }
    }

    parser: SplitParser {
      onRead: function (line) {
        try {
          root._handleEvent(JSON.parse(line))
        } catch (e) {
          console.warn("NiriService: bad event line:", line)
        }
      }
    }
  }

  // --- one-shot request/action socket ---
  Socket {
    id: requestSocket
    path: root.socketPath
    connected: root.available
  }

  function _send(requestObj) {
    if (!root.available || !requestSocket.connected) return false
    requestSocket.write(JSON.stringify(requestObj) + "\n")
    return true
  }

  function _handleEvent(event) {
    const type = Object.keys(event)[0]
    const data = event[type]

    switch (type) {
    case "WorkspacesChanged": {
      const map = {}
      for (const ws of data.workspaces) map[ws.id] = ws
      root._setWorkspaces(map)
      const focused = root.allWorkspaces.find(w => w.is_focused)
      root.focusedWorkspaceId = focused ? focused.id : ""
      root.currentOutput = focused ? (focused.output || "") : ""
      break
    }
    case "WorkspaceActivated": {
      const ws = root.workspaces[data.id]
      if (!ws) break
      const map = Object.assign({}, root.workspaces)
      for (const id in map) {
        const w = Object.assign({}, map[id])
        if (w.output === ws.output) w.is_active = (w.id === data.id)
        if (data.focused) w.is_focused = (w.id === data.id)
        map[id] = w
      }
      root._setWorkspaces(map)
      root.focusedWorkspaceId = data.id
      root.currentOutput = ws.output || ""
      break
    }
    case "WindowsChanged":
      root.windows = data.windows
      break
    case "WindowOpenedOrChanged": {
      if (!data.window) break
      const idx = root.windows.findIndex(w => w.id === data.window.id)
      const list = root.windows.slice()
      const isNew = idx < 0
      if (idx >= 0) list[idx] = data.window; else list.push(data.window)
      root.windows = list
      if (isNew) root.windowOpened(data.window)
      break
    }
    case "WindowClosed":
      root.windows = root.windows.filter(w => w.id !== data.id)
      root.windowClosed(data.id)
      break
    case "WindowFocusChanged": {
      root.windows = root.windows.map(w =>
        Object.assign({}, w, { is_focused: w.id === data.id }))
      root.windowFocusChanged(data.id)
      break
    }
    case "OutputsChanged":
      if (data.outputs) root.outputs = data.outputs
      break
    case "KeyboardLayoutsChanged":
      root.keyboardLayoutNames = data.keyboard_layouts.names
      root.currentKeyboardLayoutIndex = data.keyboard_layouts.current_idx
      break
    case "KeyboardLayoutSwitched":
      root.currentKeyboardLayoutIndex = data.idx
      break
    }
  }

  // ---- actions (mirror the subset of Hyprland dispatches Omaniri used) ----

  function focusWorkspace(id) {
    return root._send({ Action: { FocusWorkspace: { reference: { Id: id } } } })
  }

  function focusWindow(id) {
    return root._send({ Action: { FocusWindow: { id: id } } })
  }

  function closeWindow(id) {
    return root._send({ Action: { CloseWindow: { id: id } } })
  }

  function cycleKeyboardLayout() {
    return root._send({ Action: { SwitchLayout: { layout: "Next" } } })
  }

  function toggleWindowOpacityRule(id) {
    return root._send({ Action: { ToggleWindowRuleOpacity: { id: id } } })
  }

  // NOTE: `Output` is a TOP-LEVEL request in niri's IPC, not an `Action`
  // (confirmed against niri-ipc's Rust docs: docs.rs/niri-ipc → enum
  // Request::Output { output, action: OutputAction }). Easy to get wrong
  // by analogy with everything else here, which is why it's called out.
  function setOutputScale(outputName, scale) {
    return root._send({
      Output: { output: outputName, action: { Scale: { scale: scale } } }
    })
  }

  function setOutputEnabled(outputName, enabled) {
    return root._send({
      Output: { output: outputName, action: enabled ? "On" : "Off" }
    })
  }

  // ---- lookup helpers used by the ported widgets ----

  function windowByAppId(pattern) {
    const re = new RegExp(pattern, "i")
    return root.windows.find(w => re.test(w.app_id || "") || re.test(w.title || "")) || null
  }

  function workspacesForOutput(outputName) {
    return root.allWorkspaces.filter(w => w.output === outputName)
  }
}
