local wezterm = require("wezterm")
local colors = require("machiatto")

M = {}

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.tab_index + 1 .. ": " .. tab_info.active_pane.title
end

M.setup = function()
	wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
		local title = tab_title(tab)

		if tab.is_active then
			return {
				{ Foreground = { Color = colors.blue } },
				{ Background = { Color = colors.base } },
				{ Text = wezterm.nerdfonts.ple_left_half_circle_thick },
				{ Foreground = { Color = colors.base } },
				{ Background = { Color = colors.blue } },
				{ Text = " " .. title .. " " },
				{ Foreground = { Color = colors.blue } },
				{ Background = { Color = colors.base } },
				{ Text = wezterm.nerdfonts.ple_right_half_circle_thick },
			}
		end
		return {
			{ Foreground = { Color = colors.blue } },
			{ Background = { Color = colors.base } },
			{ Text = " " .. title .. " " },
		}
	end)
end
return M
