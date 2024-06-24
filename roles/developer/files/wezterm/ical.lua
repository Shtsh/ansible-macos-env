local wezterm = require("wezterm")
local lib = require("lib")

local M = {}

M.opts = {
	executable = "/opt/homebrew/bin/icalBuddy",
	show_only_next = 60, -- show only meetings that is sooner that X minutes
}

-- converts time of today like 15:00 to unix timestamp
local function convert_to_timestamp(t)
	t = lib.trim(t)
	local full_time = wezterm.time.now():format("%Y-%m-%d ") .. t .. ":00 " .. wezterm.time.now():format("%z")
	local time = wezterm.time.parse(full_time, "%Y-%m-%d %H:%M:%S %z")
	return tonumber(time:format("%s"))
end

M.get_next_meeting = function()
	local success, stdout, stderr = wezterm.run_child_process({
		M.opts.executable,
		"--includeEventProps",
		"title,datetime",
		"--propertyOrder",
		"datetime,title",
		"--noCalendarNames",
		'--dateFormat "%A"',
		"--includeOnlyEventsFromNowOn",
		"--limitItems",
		"1",
		"--excludeAllDayEvents",
		"--separateByDate",
		"--bullet",
		"",
		"--excludeCals",
		"",
		"eventsToday",
	})
	local meeting = { begin = nil, finish = nil, name = nil }
	if not success then
		wezterm.log_error("error getting the next meeting data")
		wezterm.log_error(stderr)
		return nil
	end
	local parts = wezterm.split_by_newlines(stdout)
	if #parts == 0 then
		return nil
	end
	meeting.begin = convert_to_timestamp(lib.split(parts[3], "-")[1])
	meeting.finish = convert_to_timestamp(lib.split(parts[3], "-")[2])
	meeting.name = lib.trim(parts[4])
	return meeting
end

M.time_before_start = function(m)
	return m.begin - tonumber(wezterm.time.now():format_utc("%s"))
end

M.time_before_finish = function(m)
	return m.finish - tonumber(wezterm.time.now():format_utc("%s"))
end

M.get_next_meeting_text = function(m)
	if m == nil then
		m = M.get_next_meeting()
	end
	if m == nil then
		return m
	end
	-- check if the meething starts soon enough
	local before_start = M.time_before_start(m)
	if before_start < (M.opts.show_only_next * 60) and before_start > 0 then
		return " " .. m.name .. " (in " .. before_start // 60 .. " min) "
	end
	-- meeting in progress
	local before_end = M.time_before_finish(m)
	-- first condition to remove events that start later than show_only_next
	if before_start < (M.opts.show_only_next * 60) and before_end > 0 then
		return " " .. m.name .. " (" .. before_end // 60 .. " min left) "
	end
	return nil
end

M.setup = function(opts)
	for key, _ in pairs(M.opts) do
		if not opts[key] == nil then
			M.opts[key] = opts[key]
		end
	end
end

return M
