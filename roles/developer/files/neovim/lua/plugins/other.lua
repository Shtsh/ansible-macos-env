-- Simple plugins that don't require complex configuration
return {
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		config = function()
			require("tiny-inline-diagnostic").setup()
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({})
		end,
	},
	{
		"OXY2DEV/markview.nvim", -- markdown preview
		dependencies = {
			"nvim-tree/nvim-web-devicons", -- Used by the code bloxks
		},

		config = function()
			require("markview").setup()
		end,
	},
	{ "tpope/vim-sleuth" }, -- Detect tabstop and shiftwidth automatically

	-- python virtualenv select
	{
		"Shtsh/neoconf-venom.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "folke/neoconf.nvim" },
	},

	{ "knsh14/vim-github-link" }, -- generate links to the file/line in github/gilab
	{ "mrjones2014/smart-splits.nvim", opts = {} }, -- integration with wezterm splits
}
