local wezterm = require("wezterm")

local M = { level = 0, connected = false }

M.read_battery_status = function()
	for _, b in ipairs(wezterm.battery_info()) do
		M.level = b.state_of_charge * 100
		M.connected = false
		if b.state == "Charging" then
			M.connected = true
		end
		if b.state == "Full" then
			M.connected = true
		end
	end
end

M.get_battery_icon = function()
	if M.connected then
		return wezterm.nerdfonts.cod_plug
	end
	if M.level > 90 then
		return wezterm.nerdfonts.fa_battery_full
	end
	if M.level > 60 then
		return wezterm.nerdfonts.fa_battery_three_quarters
	end
	if M.level > 30 then
		return wezterm.nerdfonts.fa_battery_half
	end
	if M.level > 10 then
		return wezterm.nerdfonts.fa_battery_quarter
	end
	return wezterm.nerdfonts.fa_battery_empty
end

M.get_battery_text = function()
	M.read_battery_status()
	return M.get_battery_icon() .. string.format(" %.0f%% ", M.level)
end

return M
