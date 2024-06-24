local wezterm = require("wezterm")
local lib = require("lib")

local M = {}

local function get_pwd(pane)
	local pwd = pane:get_current_working_dir()
	return pwd.file_path
end

local function is_path_with_number(selection)
	return not (selection:find("[/.A-Za-z0-9_-]+%.[A-Za-z0-9]+%:%d+$") == nil)
end

local function extract_file_and_line(text)
	local parts = lib.split(text, ":")
	return parts[1], parts[2]
end

local function is_path(selection)
	-- ignore anything with protocols
	if not (selection:find("^.*://") == nil) then
		return false
	end
	local path = not (selection:find("[/.A-Za-z0-9_-]+%.[A-Za-z0-9]+$") == nil)
	return path or is_path_with_number(selection)
end

local function open_in_nvim(full_path, line)
	local args = { "/opt/homebrew/bin/nvim", full_path }
	if not (line == nil) then
		args = { "/opt/homebrew/bin/nvim", "+" .. line, full_path }
	end
	local action = wezterm.action.SplitPane({
		direction = "Right",
		command = { args = args },
	})
	return action
end

M.open_selection = function(window, pane)
	local selection = window:get_selection_text_for_pane(pane)
	if not is_path(selection) then
		return wezterm.open_with(selection)
	end

	local number = nil
	if is_path_with_number(selection) then
		selection, number = extract_file_and_line(selection)
	end
	-- relative path
	-- transform relative path to absolute
	if selection:find("^%/") == nil then
		local pwd = get_pwd(pane)
		selection = pwd .. "/" .. selection
	end
	local action = open_in_nvim(selection, number)
	window:perform_action(action, pane)
end

return M
