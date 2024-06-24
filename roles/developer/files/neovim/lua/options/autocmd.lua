-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Close tree on exit
vim.api.nvim_create_autocmd({ "QuitPre" }, {
	callback = function()
		vim.cmd("NvimTreeClose")
		vim.cmd("TroubleClose")
		require("neotest").summary.close()
	end,
})
--
-- vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
-- 	callback = function()
-- 		vim.fn.system({ "tmux", "rename-window", " " .. vim.fn.expand("%:t") })
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd({ "VimLeave" }, {
-- 	callback = function()
-- 		-- local status = vim.fn.system({ "tmux", "show-options", "-gv", "window-status-current-format" })
-- 		-- vim.fn.system({ "tmux", "rename-window", status })
-- 		vim.fn.system({ "tmux", "setw", "automatic-rename" })
-- 	end,
-- })
