-- No example configuration was found for this plugin.
--
-- For detailed information on configuring this plugin, please refer to its
-- official documentation:
--
--   https://github.com/rmagatti/auto-session
--
-- If you wish to use this plugin, you can optionally modify and then uncomment
-- the configuration below.

return {
	"rmagatti/auto-session",
	dependencies = {
		"nvim-tree/nvim-tree.lua",
	},
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_restore_enabled = true,
			auto_save_enabled = true,
			auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/" },
			--post_restore_cmds = { change_nvim_tree_dir, "NvimTreeOpen" },
		})
	end,
}
