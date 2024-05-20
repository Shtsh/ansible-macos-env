return {
	"stevearc/conform.nvim",
	lazy = false,
	opts = {
		notify_on_error = false,
		format_on_save = function()
			-- format only changes using git 
			-- local hunks = require("gitsigns").get_hunks()
			-- local format = require("conform").format
			-- for i = #hunks, 1, -1 do
			-- 	local hunk = hunks[i]
			-- 	if hunk ~= nil and hunk.type ~= "delete" then
			-- 		local start = hunk.added.start
			-- 		local last = start + hunk.added.count
			-- 		-- nvim_buf_get_lines uses zero-based indexing -> subtract from last
			-- 		local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
			-- 		local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
			-- 		format({ range = range })
			-- 	end
			-- end
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			rust = { "rustfmt" },
			-- Conform can also run multiple formatters sequentially
			python = { "isort", "black" },
			-- You can use a sub-list to tell conform to run *until* a formatter
			-- is found.
			-- javascript = { { "prettierd", "prettier" } },
		},
	},
	-- "stevearc/conform.nvim"
}
