local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local utils = require("utils")
local wrapper = utils.ui.wrapper
local powerline2 = utils.ui.powerline2
local COLORS = {
	header = beautiful.calendar_fg_header,
	focus = beautiful.calendar_fg_focus,
	weekday = beautiful.calendar_fg_weekday,
}
local BACKGROUNDS = {
	weekday = beautiful.pink,
	month = beautiful.calendar_bg,
}
return function()
	local calendar = wibox.widget({
		widget = wibox.widget.calendar.month,
		date = os.date("*t"),
		font = beautiful.font,
		spacing = beautiful.spacing_md,
		fn_embed = function(widget, flag, date)
			local wg = widget
			local bg = BACKGROUNDS[flag] or beautiful.calendar_bg_normal
			local fg = COLORS[flag] or beautiful.calendar_fg
			local shape = gears.shape.circle
			if flag == "focus" then
				bg = beautiful.calendar_bg_focus
				wg = wibox.widget({
					text = date.day,
					align = "center",
					widget = wibox.widget.textbox,
				})
			end
			if flag == 'header' then 
				bg = beautiful.transparent
				shape = nil
				wg = wibox.widget({
					{
						{
							widget,
							margins = beautiful.spacing,
							widget = wibox.container.margin,
						},
						bg = beautiful.calendar_bg_normal,
						align = "center",
						widget = wibox.widget.background,
						shape = utils.ui.rounded_rect(5)
					},
					layout = wibox.container.place ,
					
				})
			end
			return wibox.widget({
				{	
					wg,
					margins = beautiful.spacing,
					widget = wibox.container.margin,
				},
				bg = bg,
				fg = fg,
				shape = shape,
				widget = wibox.container.background,
			})
		end,
	})

	local popup = awful.popup({
		bg = beautiful.transparent,
		fg = beautiful.fg_normal,
		visible = false,
		ontop = true,
		type = 'dock',
		placement = function(d)
			return awful.placement.top_right(d, {
				margins = {
					top = beautiful.bar_height + beautiful.useless_gap * 2,
					right = beautiful.useless_gap * 2,
				},
			})
		end,
		widget = calendar,
	})

	local new_month = function(prev_or_next)
		return function()
			local date = calendar:get_date()
			date.month = date.month + prev_or_next
			calendar:set_date(nil)
			calendar:set_date(date)
			popup:set_widget(calendar)
		end
	end

	popup:buttons(awful.util.table.join(
		--
		awful.button({}, 1, new_month(-1)),
		awful.button({}, 3, new_month(1))
	))

	return {
		toggle = function()
			popup.visible = not popup.visible
		end,
	}
end
