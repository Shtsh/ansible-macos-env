local wezterm = require("wezterm")
local ical = require("ical")
local colors = require("machiatto")
local battery = require("battery")

ical.setup({})
local status = {}

status.setup = function()
	wezterm.on("update-right-status", function(window, pane)
		-- demonstrates shelling out to get some external status.
		-- wezterm will parse escape sequences output by the
		-- child process and include them in the status area, too.
		local main_table = {}

		-- Next meeting if there is any
		local next_meeting = ical.get_next_meeting_text()
		if not (next_meeting == nil) then
			local next_meeting_table = {
				{ Foreground = { Color = colors.base } },
				{ Text = "" },
				{ Foreground = { Color = colors.sapphire } },
				{ Background = { Color = colors.base } },
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
