local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local utils = require("utils")
local constants = require("constants")
local my_widgets = require("widgets")

local mods = constants.mods
local my_volume = my_widgets.volume()
utils.volume.set_widget(my_volume)
local powerline = utils.ui.powerline
local powerline2 = utils.ui.powerline2
local wrapper = utils.ui.wrapper
local cw = my_widgets.calendar()
local date = wibox.widget({
	layout = wibox.layout.fixed.horizontal,
	powerline2(beautiful.black4,beautiful.black3),
	wrapper(wibox.widget.textclock("%a %b %d %Y"),{bg=beautiful.black4}),
})

date:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		cw.toggle()
	end
end)
local clock = wibox.widget({
	layout = wibox.layout.fixed.horizontal,
	powerline(beautiful.green,beautiful.black),
	{
		wibox.widget.textclock(" %H:%M"),
		widget = wibox.container.background,
		bg = beautiful.green
	},
	powerline(beautiful.black,beautiful.green),
})
local actions = wibox.widget({
	wrapper({
		widget = wibox.widget.textbox,
		markup = "  ",
		font = "JetBrainsMono Nerd Font Mono Medium 24",
	},{bg =beautiful.blue,fg =beautiful.black,}),
	powerline(beautiful.black2,beautiful.blue),
	layout = wibox.layout.fixed.horizontal
})
actions:connect_signal("button::press", function(_, _, _, button)
	awful.spawn("powermenu")
end)
local DEFAULT_OPTS = {
	widget_spacing = beautiful.spacing,
	bg = beautiful.bg_normal,
}

local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ mods.m }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ mods.m }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

awful.screen.connect_for_each_screen(function(s)
	utils.ui.set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag(utils.misc.range(1, 9), s, awful.layout.layouts[1])

	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		buttons = taglist_buttons,
		filter = awful.widget.taglist.filter.all,
		layout = {
			layout = wibox.layout.fixed.horizontal,
			spacing = beautiful.spacing,
		},
		style = { shape = gears.shape.circle },
		widget_template = {
			{
				{
					{
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				left = beautiful.spacing,
				right = beautiful.spacing,
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
		},
	})

	s.mywibox = awful.wibar({
		height = beautiful.bar_height,
		type = "dock",
		bg = beautiful.black,
		position = "top",
		screen = s,
	})

	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			actions,
			wrapper(s.mytaglist,{bg =beautiful.black2,fg =beautiful.black,}),
			powerline(beautiful.black,beautiful.black2),
		},
		{
			clock,
			layout = wibox.layout.fixed.horizontal
		},
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			wrapper(wibox.widget.systray(),{spacing=10}),
			powerline2(beautiful.black3,beautiful.black),
			wrapper({
				{
					widget = wibox.widget.textbox,
					markup = "[]=",
					font = beautiful.font
				},
				top = beautiful.spacing,
				bottom = beautiful.spacing,
				left = beautiful.spacing,
				right = beautiful.spacing,
				widget = wibox.container.margin,
			},{bg=beautiful.black3,fg=beautiful.yellow}),
			my_volume,
			my_widgets.battery(),
			date
		},
	})
end)
