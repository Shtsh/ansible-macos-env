local wezterm = require("wezterm")
local lib = require("lib")

local M = {}

M.opts = {
	executable = "/opt/homebrew/bin/icalBuddy",
	show_only_next = 60, -- show only meetings that is sooner that X minutes
	critical_text_color = "#7dc4e4",
	critical_background_color = "#24273a",
	warning_text_color = "#7dc4e4",
	warning_background_color = "#24273a",
	normal_text_color = "#7dc4e4",
	normal_background_color = "#24273a",
}

-- converts time of today like 15:00 to unix timestamp
local function convert_to_timestamp(t)
	t = lib.trim(t)
	local full_time = wezterm.time.now():format("%Y-%m-%d ") .. t .. ":00 " .. wezterm.time.now():format("%z")
	local time = wezterm.time.parse(full_time, "%Y-%m-%d %H:%M:%S %z")
	return tonumber(time:format("%s"))
end

M.get_next_meetings = function()
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
		"2",
		"--excludeAllDayEvents",
		"--separateByDate",
		"--bullet",
		"",
		"--excludeCals",
		"",
		"eventsToday",
	})
	if not success then
		wezterm.log_error("error getting the next meeting data")
		wezterm.log_error(stderr)
		return nil, nil
	end
	local parts = wezterm.split_by_newlines(stdout)
	if #parts == 0 then
		return nil, nil
	end
	local meeting = {
		begin = convert_to_timestamp(lib.split(parts[3], "-")[1]),
		finish = convert_to_timestamp(lib.split(parts[3], "-")[2]),
		name = lib.trim(parts[4]),
	}
	local next_meeting = nil
	if #parts > 5 then
		next_meeting = {
			begin = convert_to_timestamp(lib.split(parts[5], "-")[1]),
			finish = convert_to_timestamp(lib.split(parts[5], "-")[2]),
			name = lib.trim(parts[6]),
		}
	end

	return meeting, next_meeting
end

local function time_before_start(m)
	return m.begin - tonumber(wezterm.time.now():format_utc("%s"))
end

local function time_before_finish(m)
	return m.finish - tonumber(wezterm.time.now():format_utc("%s"))
end

M.format_meeting_text = function(meeting)
	-- check if the meething starts soon enough
	local before_start = time_before_start(meeting)
	if before_start < (M.opts.show_only_next * 60) and before_start > 0 then
		return " " .. meeting.name .. " (in " .. before_start // 60 .. " min) "
	end
	-- meeting in progress
	local before_end = time_before_finish(meeting)
	-- first condition to remove events that start later than show_only_next
	if before_start < (M.opts.show_only_next * 60) and before_end > 0 then
		return " " .. meeting.name .. " (" .. before_end // 60 .. " min left) "
	end
	return nil
end

M.get_meeting_colors = function(meeting)
	local before_start = time_before_start(meeting)
	if before_start > 0 and before_start < 5 * 60 then
		return { text = M.opts.critical_text_color, background = M.opts.critical_background_color }
	end
	if before_start > 0 and before_start < 10 * 60 then
		return { text = M.opts.warning_text_color, background = M.opts.warning_background_color }
	end
	return { text = M.opts.normal_text_color, background = M.opts.normal_background_color }
end

M.get_next_meeting_data = function()
	local meeting, next_meeting = M.get_next_meetings()
	if meeting == nil then
		return nil, nil
	end
	if next_meeting == nil then
		return M.format_meeting_text(meeting), M.get_meeting_colors(meeting)
	end
	local before_next = time_before_start(next_meeting)
	if before_next < 600 then -- Show info about next neeting 10 minutes before
		return M.format_meeting_text(next_meeting), M.get_meeting_colors(next_meeting)
	end
	return M.format_meeting_text(meeting), M.get_meeting_colors(meeting)
end

M.setup = function(opts)
	for key, _ in pairs(M.opts) do
		if not (opts[key] == nil) then
			M.opts[key] = opts[key]
		end
	end
end

return M
