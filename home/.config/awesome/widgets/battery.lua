local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("utils")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local wrapper = utils.ui.wrapper
local powerline2 = utils.ui.powerline2
local DEFAULT_OPTS = {
	timeout = 10,
	bat_item = 0,
	notify = true,
	notification_level = {
		happy = 70,
		tired = 20,
		sad = 10,
	},
}

local ICONS = {
	normal = {
		[0] = " ",
		[10] = " ",
		[20] = " ",
		[30] = " ",
		[40] = " ",
		[50] = " ",
		[60] = " ",
		[70] = " ",
		[80] = " ",
		[90] = " ",
		[100] = " ",
	},
}

local NOTI_TYPE = { NONE = nil, HAPPY = "happy", SAD = "sad", TIRED = "tired", CHARGING = "charging" }

return function(opts)
	opts = utils.misc.tbl_override(DEFAULT_OPTS, opts or {})

	local state = {
		current_level = 0,
		current_color = "",
		notified = NOTI_TYPE.NONE,
	}

	local notify = function(type, text)
		local types = {charging="normal",tired="low",sad="critical"}
		local preset_type = types[type] or "normal"--type == NOTI_TYPE.CHARGING and "normal" or "critical"
		if opts.notify and state.notified ~= type then
			naughty.notify({
				preset = naughty.config.presets[preset_type],
				text = text,
			})
			state.notified = type
		end
	end

	local icon = wibox.widget({
		markup = utils.ui.colorize_text(ICONS.normal[state.current_level], beautiful.battery_happy),
		font = beautiful.font,
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local percentage_text = wibox.widget({
		id = "percent_text",
		text = state.current_level .. "%",
		font = beautiful.font,
		widget = wibox.widget.textbox,
	})

	local percentage = wibox.container.background(percentage_text)

	local widget = wibox.widget({
		powerline2(beautiful.blue3,beautiful.black3),
		{
			{
				{
					icon,
					top = beautiful.spacing,
					-- bottom = beautiful.spacing,
					widget = wibox.container.margin,
				},
				widget = wibox.container.background,
				bg = beautiful.blue3
			},
			widget  = wibox.container.rotate,
			direction = 'west',
		},
		wrapper(percentage,{bg=beautiful.black3}),
		layout = wibox.layout.fixed.horizontal,
	})

	watch("acpi -i", opts.timeout, function(_, stdout)
		local status, charge_str, _ =
			string.match(stdout, "Battery " .. opts.bat_item .. ": ([%a%s]+), (%d?%d?%d)%%,?(.*)")

		--------------------------------------------------------
		local level = math.floor(tonumber(charge_str))
		local tens = math.floor(level / 10) * 10
		local color = beautiful.fg_normal

		if status == "Charging" then
			color = beautiful.battery_charging
			notify(NOTI_TYPE.CHARGING, "Battery is charging...") --🌲
		elseif level <= opts.notification_level.sad then
			color = beautiful.battery_sad
			notify(NOTI_TYPE.SAD, "Battery is low!") --📛
		elseif level <= opts.notification_level.tired then
			color = beautiful.battery_tired
			notify(NOTI_TYPE.TIRED, "Battery is getting low!") --⚠️
		end
		percentage_text.text = level .. "% "
		percentage.fg = color

		if state.current_color ~= color or state.current_level ~= tens then
			icon.markup = utils.ui.colorize_text(ICONS.normal[tens], beautiful.fg_normal)
		end

		state.current_level = tens
		state.current_color = color
	end)

	return widget
end