-- No example configuration was found for this plugin.
--
-- For detailed information on configuring this plugin, please refer to its
-- official documentation:
--
--   https://github.com/folke/which-key.nvim
--
-- If you wish to use this plugin, you can optionally modify and then uncomment
-- the configuration below.

return {
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	config = function() -- This is the function that runs, AFTER loading
		require("which-key").setup()

		-- Document existing key chains
		require("which-key").register({
			["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
			["<leader>g"] = { name = "[G]it Hunk", _ = "which_key_ignore" },
			["<leader>t"] = { name = "[T]ests", _ = "which_key_ignore" },
		})
		-- visual mode
		require("which-key").register({
			["<leader>g"] = { "[G]it Hunk" },
		}, { mode = "v" })
	end,
	-- "folke/which-key.nvim"
}
