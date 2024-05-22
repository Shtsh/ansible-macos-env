return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "macchiato",
		})
		vim.cmd("colorscheme catppuccin")
		vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#6e738d", bg = "" })
	end,
}
