local wezterm = require("wezterm")
local lib = require("lib")

local M = { mouse_battery = nil, keyboard_battery = nil }

M.opts = {
	executable = "/Users/aliparin/.cargo/bin/battery-status",
	mouse_name = "MX% Master",
	keyboard_name = "Defy",
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
	M.keyboard_battery = nil
	local success, stdout, stderr = wezterm.run_child_process({
		M.opts.executable,
		"--bluetooth-support",
		"--dygma-support",
	})

	if not success then
		wezterm.log_error("error getting battery data")
		wezterm.log_error(stderr)
		return nil, nil
	end
	local parts = wezterm.split_by_newlines(stdout)
	if #parts == 0 then
		return nil, nil
	end
	for _, value in pairs(parts) do
		if value:find(M.opts.mouse_name) then
			M.mouse_battery = lib.split(value, "%:")[2]
			M.mouse_battery = lib.trim(M.mouse_battery)
		end
		if value:find(M.opts.keyboard_name) then
			M.keyboard_battery = lib.split(value, "%:")[2]
			M.keyboard_battery = lib.trim(M.keyboard_battery)
		end
	end
	return M.mouse_battery, M.keyboard_battery
end

M.get_mouse_text = function ()
	if M.mouse_battery == nil then
		return nil
	end
	return wezterm.nerdfonts.md_mouse .. " " .. M.mouse_battery .. "% "
end

M.get_keyboard_text = function ()
	if M.keyboard_battery == nil then
		return nil
	end
	return wezterm.nerdfonts.md_keyboard .. " " .. M.keyboard_battery .. "% "
end

return M
