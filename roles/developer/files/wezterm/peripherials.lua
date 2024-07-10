local wezterm = require("wezterm")
local lib = require("lib")

local M = { mouse_battery = nil, mouse_battery_status = nil, keyboard_battery_status = nil, keyboard_battery = nil }

M.opts = {
	executable = "/Users/aliparin/.cargo/bin/battery-status",
	mouse_names = { "MX Master 3S" },
	keyboard_names = { "Dygma Defy", "Defy BLE - 2" },
	keyboard_fg_color = "#c6a0f6",
	mouse_fg_color = "#8bd5ca",
	keyboard_bg_color = "#24273a",
	mouse_bg_color = "#24273a",
}

M.setup = function(opts)
	for key, _ in pairs(M.opts) do
		if not (opts[key] == nil) then
			M.opts[key] = opts[key]
		end
	end
end

M.read_battery_status = function()
	M.mouse_battery = nil
	M.mouse_battery_status = nil
	M.keyboard_battery_status = nil
	M.keyboard_battery = nil
	local success, stdout, stderr = wezterm.run_child_process({
		M.opts.executable,
		"--bluetooth-support",
		"--dygma-support",
		"--json",
	})

	if not success then
		wezterm.log_error("error getting battery data")
		wezterm.log_error(stderr)
		return nil
	end
	local parsed = wezterm.json_parse(stdout)
	for _, value in pairs(parsed) do
		if lib.has_value(M.opts.mouse_names, value.name) then
			M.mouse_battery = value.battery_level
			M.mouse_battery_status = value.battery_status
		end
		if lib.has_value(M.opts.keyboard_names, value.name) then
			M.keyboard_battery = value.battery_level
			M.keyboard_battery_status = value.battery_status
		end
	end
end

M.get_mouse_text = function()
	if M.mouse_battery == nil then
		return nil
	end
	return wezterm.nerdfonts.md_mouse .. " " .. M.mouse_battery .. "% "
end

M.get_keyboard_text = function()
	if M.keyboard_battery == nil then
		return nil
	end
	-- Defy doesn't report charge level properly
	-- when connected via cable
	if M.keyboard_battery == "1/1" then
		return wezterm.nerdfonts.md_keyboard .. " "
	end
	if M.keyboard_battery_status == "Unknown" then
		return wezterm.nerdfonts.md_keyboard .. " "
	end
	return wezterm.nerdfonts.md_keyboard .. " " .. M.keyboard_battery .. "% "
end

return M
