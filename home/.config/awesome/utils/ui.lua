local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local M = {}

M.set_wallpaper = function(s)
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

M.rounded_rect = function(radius)
	radius = radius or beautiful.border_radius
	return function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, radius)
	end
end
M.powerline = function(color,bg)
	return wibox.widget({
		{
			shape = (function(cr, width, height, degree)
				cr:move_to(26, 0)
				cr:line_to(0, 26)
				cr:line_to(26, 26)
				cr:close_path()
			end),
			color        = color,
			forced_width = 26,
			widget       = wibox.widget.separator,
		},
		widget = wibox.container.background,
		bg =bg,
	})
end
M.powerline2 = function(color,bg)
	return wibox.widget({
		{	
			shape = (function(cr, width, height, degree)
				cr:set_source(gears.color(color))
				cr:move_to(0, 0)
				-- gears.shape.arc(cr, 25, 25, 15, math.pi, math.pi/2)
				gears.shape.pie(cr,26,26,0,math.pi*2)
				cr:fill()
				cr:close_path()
			end),
			color        = color,
			forced_width = 13,
			widget       = wibox.widget.separator,
		},
		widget = wibox.container.background,
		bg = bg,
	})
end
M.wrapper = function(wg,opts)
	local spacing = opts.spacing or beautiful.spacing
	return wibox.widget({
		{	
			wg,
			left = spacing,
			right = spacing,
			top = spacing/2.4,
			bottom = spacing/2.4,
			widget = wibox.container.margin,
		},
		widget = wibox.container.background,
		bg = opts.bg,
		fg = opts.fg
	})
end
M.colorize_text = function(text, color)
	return "<span foreground='" .. color .. "'> " .. text .. "</span>"
end

return M
