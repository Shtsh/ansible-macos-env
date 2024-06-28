-- Simple plugins that don't require complex configuration
return {
	{
		"ellisonleao/glow.nvim",
		config = function()
			require("glow").setup({
				style = "dark",
				width_ratio = 0.93, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
				height_ratio = 0.93,
			})
		end,
		cmd = "Glow",
	},
	{ "folke/trouble.nvim", opts = {} },
	{ "tpope/vim-sleuth" }, -- Detect tabstop and shiftwidth automatically

	-- python virtualenv select
	{
		"Shtsh/neoconf-venom.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "folke/neoconf.nvim" },
	},

	{ "knsh14/vim-github-link" }, -- generate links to the file/line in github/gilab
	{ "mrjones2014/smart-splits.nvim", opts = {} }, -- integration with wezterm splits
}
