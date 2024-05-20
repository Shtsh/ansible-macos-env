-- No example configuration was found for this plugin.
--
-- For detailed information on configuring this plugin, please refer to its
-- official documentation:
--
--   https://github.com/nvim-treesitter/nvim-treesitter
--
-- If you wish to use this plugin, you can optionally modify and then uncomment
-- the configuration below.

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-context", branch = "master" },
		{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
	},
	lazy = false,
	build = ":TSUpdate",
	opts = {
		event = { "BufReadPre", "BufNewFile" },
		ensure_installed = {
			"bash",
			"c",
			"go",
			"html",
			"javascript",
			"lua",
			"luadoc",
			"puppet",
			"python",
			"regex",
			"rust",
			"typescript",
			"markdown",
			"markdown_inline",
			"vim",
			"vimdoc",
		},
		-- Autoinstall languages that are not installed
		auto_install = true,
		highlight = {
			enable = true,
			-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
			--  If you are experiencing weird indenting issues, add the language to
			--  the list of additional_vim_regex_highlighting and disabled languages for indent.
			-- additional_vim_regex_highlighting = { "ruby" },
		},
		indent = { enable = true, disable = {} },
		textobjects = {
			select = {
				enable = true,

				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,

				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					-- You can optionally set descriptions to the mappings (used in the desc parameter of
					-- nvim_buf_set_keymap) which plugins like which-key display
					["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
					-- You can also use captures from other query groups like `locals.scm`
					["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
				},
				-- You can choose the select mode (default is charwise 'v')
				--
				-- Can also be a function which gets passed a table with the keys
				-- * query_string: eg '@function.inner'
				-- * method: eg 'v' or 'o'
				-- and should return the mode ('v', 'V', or '<c-v>') or a table
				-- mapping query_strings to modes.
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "<c-v>", -- blockwise
				},
				-- If you set this to `true` (default is `false`) then any textobject is
				-- extended to include preceding or succeeding whitespace. Succeeding
				-- whitespace has priority in order to act similarly to eg the built-in
				-- `ap`.
				--
				-- Can also be a function which gets passed a table with the keys
				-- * query_string: eg '@function.inner'
				-- * selection_mode: eg 'v'
				-- and should return true or false
				include_surrounding_whitespace = true,
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]m"] = "@function.outer",
					["]p"] = "@parameter.inner",
					-- ["]]"] = { query = "@class.outer", desc = "Next class start" },
					["]]"] = {
						query = { "@context$" },
						query_group = "context",
						desc = "Next context",
					},
					["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
				},
				goto_next_end = {
					["]M"] = "@function.outer",
					["]["] = "@class.outer",
					["]A"] = { query = { "@loop.outer", "@conditional.outer" } },
				},
				goto_previous_start = {
					["[o"] = "@loop.*",
					["[m"] = "@function.outer",
					["[p"] = "@parameter.inner",
					["[["] = {
						query = { "@context$" },
						query_group = "context",
						desc = "Previous context",
					},
					["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
				},
				goto_previous_end = {
					["[M"] = "@function.outer",
					["[]"] = "@class.outer",
				},
				-- Below will go to either the start or the end, whichever is closer.
				-- Use if you want more granular movements
				-- Make it even more gradual by adding multiple queries and regex.
				goto_next = {},
				goto_previous = {},
			},
		},
	},
	config = function(_, opts)
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

		-- Prefer git instead of curl in order to improve connectivity in some environments
		require("treesitter-context").setup({})
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup(opts)

		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	end,
}
