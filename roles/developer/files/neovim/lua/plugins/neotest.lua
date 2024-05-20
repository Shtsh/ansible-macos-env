return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-python",
		"rouge8/neotest-rust",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-python")({
					args = { "--log-level", "ERROR", "-n", "0", "--no-cov" },
					runner = "pytest",
				}),
				require("neotest-rust"),
			},
		})
	end,
}
