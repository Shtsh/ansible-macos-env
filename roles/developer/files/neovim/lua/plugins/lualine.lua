-- No example configuration was found for this plugin.
--
-- For detailed information on configuring this plugin, please refer to its
-- official documentation:
--
--   https://github.com/nvim-lualine/lualine.nvim
--
-- If you wish to use this plugin, you can optionally modify and then uncomment
-- the configuration below.

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "Shtsh/neoconf-venom.nvim" },
	config = function()
		local lazy_status = require("lazy.status")
		local venom = require("venom")
		require("lualine").setup({
			options = {
				theme = "catppuccin",
				component_separators = " ",
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat" },
					{ venom.statusline },
					{ "filetype" },
				},
			},
		})
	end,
}
