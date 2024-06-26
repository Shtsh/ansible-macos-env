-- Pull in the wezterm API
local wezterm = require("wezterm")

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

local status = require("status_bar")
status.setup()

local tabs = require("tabs")
tabs.setup()

local open = require("open_with")

-- This will hold the configuration.
local config = wezterm.config_builder()
-- shell
config.default_prog = { "/opt/homebrew/bin/fish" }
config.scrollback_lines = 10000
-- tabs
config.use_fancy_tab_bar = false
config.tab_max_width = 100
config.show_new_tab_button_in_tab_bar = false

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Macchiato"
	else
		return "Catppuccin Latte"
	end
end

-- changing the color scheme:
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
-- Font
config.font = wezterm.font("FiraCode Nerd Font", { weight = "Regular" })
config.font_size = 14

config.keys = {
	{ key = "u", mods = "SUPER", action = wezterm.action_callback(function()
		wezterm.plugin.update_all()
	end) },
	{ key = "s", mods = "SUPER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "S", mods = "SUPER|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{
		key = "phys:Space",
		mods = "SHIFT",
		action = wezterm.action.QuickSelectArgs({
			action = wezterm.action_callback(function(window, pane)
				open.open_selection(window, pane)
			end),
		}),
	},
}

-- need to disable all default patterns in order to put own rules to the top
config.disable_default_quick_select_patterns = true
config.quick_select_patterns = {
	-- file with line number
	-- mostly to work with grep -i results
	"[/.A-Za-z0-9_-]+\\.[A-Za-z0-9]+:\\d+",
	-- custom url regex as default one did't work if the url is in quotes
	"https?:\\/\\/(?:www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b(?:[-a-zA-Z0-9()@:%_\\+.~#?&\\/=]*)",
	-- company hosts
	-- cannot use () as only the group will be selected
	"\\S+\\.corp\\.\\w+\\.com",
	"\\S+\\.prod\\.\\w+\\.com",
	-- copy the command from the prompt
	"[#\\$❯] (.+)",

	-- below are the default ones
	-- taken from wezterm/wezterm-gui/src/overlay/quickselect.rs

	-- markdown_url
	"\\[[^]]*\\]\\(([^)]+)\\)",
	-- url
	"(?:https?://|git@|git://|ssh://|ftp://|file:///)\\S+",
	-- diff_a
	"--- a/(\\S+)",
	-- diff_b
	"\\+\\+\\+ b/(\\S+)",
	-- docker
	"sha256:([0-9a-f]{64})",
	-- path
	"(?:[.\\w\\-@~]+)?(?:/[.\\w\\-@]+)+",
	-- color
	"#[0-9a-fA-F]{6}",
	-- uuid
	"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}",
	-- ipfs
	"Qm[0-9a-zA-Z]{44}",
	-- sha
	"[0-9a-f]{7,40}",
	-- ip
	"\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}",
	-- ipv6
	"[A-f0-9:]+:+[A-f0-9:]+[%\\w\\d]+",
	-- address
	"0x[0-9a-fA-F]+",
	-- number
	"[0-9]{4,}",
}

-- plugin to switch panes via C-[hjkl] respecting nvim splits
smart_splits.apply_to_config(config, {
	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

-- fullscreen startup
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():toggle_fullscreen()
end)

-- and finally, return the configuration to wezterm
return config
