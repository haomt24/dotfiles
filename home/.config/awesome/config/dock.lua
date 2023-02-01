local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local utils = require("utils")

local tasklist_buttons = awful.util.table.join(
	awful.button(
		{},
		1,
		function(c)
			if c == client.focus then
				c.minimized = true
			else
				-- Without this, the following
				-- :isvisible() makes no sense
				c.minimized = false
				if not c:isvisible() and c.first_tag then
					c.first_tag:view_only()
				end
				-- This will also un-minimize
				-- the client, if needed
				c:emit_signal('request::activate')
				c:raise()
			end
		end
	),
	awful.button(
		{},
		2,
		function(c)
			c:kill()
		end
	),
	awful.button(
		{},
		4,
		function()
			awful.client.focus.byidx(1)
		end
	),
	awful.button(
		{},
		5,
		function()
			awful.client.focus.byidx(-1)
		end
	)
)
awful.screen.connect_for_each_screen(function(s)
    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.alltags,
        buttons  = tasklist_buttons,
        layout   = {
            spacing_widget = {
                {
                    forced_width  = 5,
                    forced_height = 24,
                    thickness     = 1,
                    color         = '#777777',
                    widget        = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            spacing = 10,
            layout  = wibox.layout.fixed.horizontal
        },
        style = { shape = utils.ui.rounded_rect(5) },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            -- {
            --     wibox.widget.base.make_widget(),
            --     forced_height = 5,
            --     id            = 'background_role',
            --     widget        = wibox.container.background,
            --     shape = utils.ui.rounded_rect(5)
            -- },
            {
                {
                    {
                        id     = 'clienticon',
                        widget = awful.widget.clienticon,
                    },
                    margins = 5,
                    widget  = wibox.container.margin
                },
                id            = 'background_role',
                widget        = wibox.container.background,
            },
            nil,
            create_callback = function(self, c, index, objects) --luacheck: no unused args
                self:get_children_by_id('clienticon')[1].client = c
            end,
            layout = wibox.layout.align.vertical,
        },
    }
    s.dock = awful.wibar({
		height = 50,
		type = "dock",
		bg = beautiful.transparent,
		position = "bottom",
		screen = s,
	})
    
    local launcherbutton = wibox.widget({
        {   
            {
                widget = wibox.widget.textbox,
                markup = "",
                font = "JetBrainsMono Nerd Font Mono Medium 24"
            },
            widget = wibox.container.margin,
            left = beautiful.spacing*1.5,
            right = beautiful.spacing*1.5,
            top = beautiful.spacing,
            bottom = beautiful.spacing,
        },
        widget = wibox.widget.background,
        bg = beautiful.transparent,
        fg = beautiful.dock_fg,
        shape = utils.ui.rounded_rect(5),
       
    })
    launcherbutton:connect_signal("button::press", function(_, _, _, button)
        if (button == 1) then awful.spawn("rofi -show drun -theme .config/rofi/launcher.rasi")
        end
    end)
    s.dock:setup({
        {
            {
                {
                    {   
                        layout  = wibox.layout.fixed.horizontal,
                        {
                            launcherbutton,
                            widget = wibox.container.margin,
                            right = 2,
                            left = 2
                        },
                        s.mytasklist
                    },
                    widget = wibox.container.margin,
                    left = beautiful.spacing,
                    right = beautiful.spacing,
                    top = beautiful.spacing,
                    bottom = beautiful.spacing,
                },
                align = "center",
                widget = wibox.widget.background,
                bg = beautiful.dock_bg,
                shape = utils.ui.rounded_rect(5)
            },
            widget = wibox.container.margin,
            bottom = beautiful.spacing,
        },
        layout = wibox.container.place,
    })
end)