-- No example configuration was found for this plugin.
--
-- For detailed information on configuring this plugin, please refer to its
-- official documentation:
--
--   https://github.com/navarasu/onedark.nvim
--
-- If you wish to use this plugin, you can optionally modify and then uncomment
-- the configuration below.

return {
	"navarasu/onedark.nvim",
	enabled = false,
	priority = 100,
	config = function()
		require("onedark").setup({
			style = "cool",
		})
		vim.cmd("colorscheme onedark")
	end,
}
