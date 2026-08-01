-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omaniri's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMANIRI_PATH") or "/usr/share/omaniri") .. "/default/hypr/bootstrap.lua")

-- Disable all Omaniri default bindings. Add your own in hypr/bindings.lua.
-- omaniri_default_bindings = false
--
-- Or disable only bindings for Omaniri's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omaniri_preinstalled_bindings = false

-- Load Omaniri defaults.
require("default.hypr.omaniri")

-- Put your personal overrides in these files. They're loaded after Omaniri's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })
