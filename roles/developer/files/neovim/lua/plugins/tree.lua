return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		require("nvim-tree").setup({
			view = {
				width = 35,
				relativenumber = true,
			},
			-- change folder arrow icons
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			renderer = {
				icons = {
					web_devicons = { file = { color = false } },
					show = { diagnostics = true, bookmarks = true, git = false },
				},
				highlight_git = "name",
				highlight_opened_files = "icon",
				highlight_modified = "icon",
				highlight_diagnostics = "none",
				special_files = {},
			},
			filters = {
				custom = { ".DS_Store", "__pycache__" },
			},
			git = {
				ignore = false,
			},
			update_focused_file = {
				enable = true,
				update_root = {
					enable = false,
					ignore_list = {},
				},
				exclude = false,
			},
		})
		vim.api.nvim_command("highlight NvimTreeExecFile guifg=none")
		-- vim.api.nvim_set_hl(0, "NvimTreeExecFile", { fg = none, bg = none, sp = none })
	end,
}
