local wezterm = require("wezterm")
local ical = require("ical")
local colors = require("machiatto")
local battery = require("battery")

ical.setup({
	critical_text_color = colors.red,
	critical_background_color = colors.base,
	warning_text_color = colors.yellow,
	warning_background_color = colors.base,
	normal_text_color = colors.sapphire,
	normal_background_color = colors.base,
})
local status = {}

status.setup = function()
	wezterm.on("update-right-status", function(window, pane)
		-- demonstrates shelling out to get some external status.
		-- wezterm will parse escape sequences output by the
		-- child process and include them in the status area, too.
		local main_table = {}

		-- Next meeting if there is any
		local next_meeting, color_data = ical.get_next_meeting_data()
		if color_data == nil then
			color_data = { text = colors.sapphire, background = colors.base }
		end
		if not (next_meeting == nil) then
			local next_meeting_table = {
				{ Foreground = { Color = color_data.background} },
				{ Text = "" },
				{ Foreground = { Color = color_data.text } },
				{ Background = { Color = color_data.background } },
				{ Text = next_meeting },
				"ResetAttributes",
			}
			for _, v in pairs(next_meeting_table) do
				table.insert(main_table, v)
			end
		end

		-- battery info
		local battery_table = {
			{ Foreground = { Color = colors.peach } },
			{ Background = { Color = colors.base } },
			{ Text = "" },
			{ Background = { Color = colors.peach } },
			{ Foreground = { Color = colors.base } },
			{ Text = battery.get_battery_text() },
			"ResetAttributes",
		}

		for _, v in pairs(battery_table) do
			table.insert(main_table, v)
		end

		-- Current date and time
		local time_table = {
			{ Foreground = { Color = colors.blue } },
			{ Background = { Color = colors.peach } },
			{ Text = "" },
			{ Background = { Color = colors.blue } },
			{ Foreground = { Color = colors.base } },
			{ Text = wezterm.nerdfonts.fa_clock_o .. "  " .. wezterm.strftime("%d/%m %H:%M ") },
			"ResetAttributes",
		}
		for _, v in pairs(time_table) do
			table.insert(main_table, v)
		end

		window:set_right_status(wezterm.format(main_table))
	end)
end

return status
