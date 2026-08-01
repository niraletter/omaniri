-- Restore workspace layouts saved by omaniri-hyprland-workspace-layout-toggle.

local paths = require("default.hypr.paths")
local require_all = require("default.hypr.require_all")

local layouts_dir = paths.state_home .. "/omaniri/workspace-layouts"

require_all.files(layouts_dir, "omaniri.workspace-layouts", { reload = true })
