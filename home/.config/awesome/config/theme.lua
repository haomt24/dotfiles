local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gears = require("gears")
local naughty = require("naughty")
local constants = require("constants")
local utils = require("utils")

local theme = {}

theme.transparent = "#00000000"
theme.font = "JetBrainsMono Nerd Font Bold 9"

theme.black = "#22262e"
theme.red = "#ff0000"
theme.green = "#88d6ac"
theme.yellow = "#e5c07a"
theme.orange = "#FFA066"
theme.white = "#ffffff"
theme.gray = "#d8dee9"
theme.pink2 = "#f5c2e7"
theme.pink = "#f292a4"
theme.blue = "#81a1c1"
theme.blue2 = "#8caaee"
theme.blue3 = "#9ad4e0"
theme.black2 = "#2d3139"
theme.black3 = "#2d3239"
theme.black4 = "#515368"
-- bg
theme.bg_normal = theme.black
theme.bg_focus = theme.pink2
theme.bg_urgent = theme.red
theme.bg_systray = theme.bg_normal

-- fg
theme.fg_normal = theme.white
theme.fg_focus = theme.yellow
theme.fg_urgent = theme.white

-- spacing
theme.spacing = dpi(5)
theme.spacing_md = dpi(10)
theme.spacing_lg = dpi(8)
theme.spacing_xl = dpi(10)

-- border
theme.useless_gap = dpi(5)
theme.border_width = dpi(1)
theme.border_radius = dpi(0)
theme.border_focus = theme.transparent
theme.border_normal = theme.transparent
-- taglist
theme.taglist_bg = theme.bg_normal
theme.taglist_bg_focus = theme.blue2
theme.taglist_bg_urgent = theme.red
theme.taglist_bg_occupied = theme.gray
-- dock 
theme.dock_bg = theme.black3
theme.dock_fg = theme.white
-- tasklist
theme.tasklist_bg_focus = theme.white.."20"
theme.tasklist_bg_normal = theme.black.."a0"
theme.tasklist_bg_urgent = theme.red.."90"
-- wallpaper
theme.wallpaper = gears.surface.load_uncached(constants.wallpapers .. "bg.jpg")

-- bar
theme.bar_height = dpi(26)
-- clock
theme.clock_color = theme.green
-- system tray
theme.systray_icon_spacing = theme.spacing
theme.systray_max_rows = 7
theme.bg_systray = theme.black
-- ********************************* --
--
--              Naughty
--
-- ********************************* --

local nc = naughty.config
nc.defaults.border_width = 2
nc.defaults.border_color = theme.pink
nc.defaults.margin = theme.spacing_lg
nc.defaults.timeout = 3
nc.padding = theme.spacing
nc.padding = theme.spacing_xl
nc.presets.critical.bg = theme.white
nc.presets.critical.fg = theme.red
nc.presets.low.bg = theme.white
nc.presets.low.fg = theme.orange
nc.presets.normal.bg = theme.white
nc.presets.normal.fg = theme.pink
nc.spacing = theme.spacing
nc.defaults['icon_size'] = 80
-- ********************************* --
--
--              Widgets
--
-- ********************************* --
-- battery
theme.battery_happy = theme.fg_normal
theme.battery_tired = theme.yellow
theme.battery_sad = theme.red
theme.battery_charging = theme.blue3

-- calendar
theme.calendar_bg = theme.black--"#2b313d"
theme.calendar_bg_focus = theme.green
theme.calendar_bg_normal = theme.black4
-- theme.calendar_bg_focus = theme.green

return theme
