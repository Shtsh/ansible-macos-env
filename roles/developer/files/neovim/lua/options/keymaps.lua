-- Hotkeys

-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- paste without replacing default register
vim.keymap.set("n", "P", '"_dP')
-- Sane redo
vim.keymap.set("n", "U", "<C-R>")

-- Diagnostic keymaps
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- exit insert mode on douple press of navigation
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })
vim.keymap.set("i", "kj", "<ESC>", { desc = "Exit insert mode" })

-- session
vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
vim.keymap.set("n", "<leader>we", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory

-- Movement

-- g
vim.keymap.set("n", "gd", function()
	require("telescope.builtin").lsp_definitions()
end, { desc = "[G]oto [D]efinition" })
vim.keymap.set("n", "gD", function()
	require("telescope.builtin").lsp_definitions({ jump_type = "vsplit" })
end, { desc = "[G]oto [D]efinition" })

-- ][
-- next/previous git change
-- next
vim.keymap.set("n", "]c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "]c", bang = true })
	else
		package.loaded.gitsigns.nav_hunk("next")
	end
end, { desc = "Next Git change" })
--previous
vim.keymap.set("n", "[c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		package.loaded.gitsigns.nav_hunk("prev")
	end
end, { desc = "Previous Git change" })

vim.keymap.set("n", "[x", function()
	-- local bufnr = vim.api.nvim_get_current_buf()
	-- local navic = require("nvim-navic")
	-- local currentElement = navic.get_data(bufnr)
	-- local parent = currentElement[#currentElement -1]
	-- if not parent then
	-- 	vim.notify("Already at the highest parent.")
	-- 	return
	-- end
	-- local parentPos = parent.scope.start
	-- vim.api.nvim_win_set_cursor(0, { parentPos.line, parentPos.character })
	require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true, desc = "Jump to conte[X]t" })
--Workspace

-- diagnostics
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostics" })
vim.keymap.set("n", "<leader>x", function()
	require("trouble").toggle("workspace_diagnostics")
end, { desc = "Workspace diagnostics" })
-- split
vim.keymap.set("n", "<leader>s", function()
	vim.cmd("vsplit")
end, { desc = "[S]plit" })

-- destroy active buffer
vim.keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>Q", "<cmd>close<CR>", { desc = "Close window" })

-- nvim-tree
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file [e]xplorer" }) -- toggle file explorer

-- Code modifications

-- rename
vim.keymap.set("n", "<leader>r", function()
	vim.lsp.buf.rename()
end, { desc = "[R]ename" })

-- commenting linewise
-- Toggle current line or with count
vim.keymap.set("n", "<leader>c", function()
	return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)" or "<Plug>(comment_toggle_linewise_count)"
end, { expr = true, desc = "Toggle [C]omment" })
-- Toggle in VISUAL mode
vim.keymap.set("x", "<leader>c", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle [C]omment" })

-- move selection Up/Down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- actions
vim.keymap.set("n", "<leader>a", function()
	vim.lsp.buf.code_action()
end, { desc = "[A]ction" })

-- selection format
-- support depends on LSP server
vim.keymap.set("v", "<leader>;", function()
	require("conform").format({ async = true, lsp_fallback = false })
end, { desc = "Format" })
vim.keymap.set("n", "<leader>;", function()
	require("conform").format({ async = true, lsp_fallback = false })
end, { desc = "Format" })

-- Search
--
-- references
vim.keymap.set("n", "<leader>fr", function()
	require("telescope.builtin").lsp_references()
end, { desc = "[R]eferences" })

vim.keymap.set("n", "<leader>z", function()
	require("telescope.builtin").lsp_references()
end, { desc = "References" })

-- implementations
vim.keymap.set("n", "<leader>fi", function()
	require("telescope.builtin").lsp_implementations()
end, { desc = "[I]mplementations" })
-- workspace symbols
vim.keymap.set("n", "<leader>fs", function()
	require("telescope.builtin").lsp_dynamic_workspace_symbols()
end, { desc = "Workspace [S]ymbols" })
-- document symbols
vim.keymap.set("n", "<leader>fd", function()
	require("telescope.builtin").lsp_document_symbols()
end, { desc = "[D]ocument symbols" })
--help
vim.keymap.set("n", "<leader>f?", function()
	require("telescope.builtin").help_tags()
end, { desc = "Help" })
-- find current word
vim.keymap.set("n", "<leader>fw", function()
	require("telescope.builtin").grep_string()
end, { desc = "[W]ord" })
-- find files
vim.keymap.set("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "[F]iles" })
-- find in current buffer
vim.keymap.set("n", "/", function()
	require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "[/] Fuzzily search in current buffer" })
-- grep in files
vim.keymap.set("n", "?", function()
	require("telescope.builtin").live_grep()
end, { desc = "Live [g]rep" })
-- Find in diagnostics
vim.keymap.set("n", "<leader>fD", function()
	require("telescope.builtin").diagnostics()
end, { desc = "[D]iagnostics" })
-- open the last search
vim.keymap.set("n", "<leader>fn", function()
	require("telescope.builtin").resume()
end, { desc = "[n]ext" })
-- find in recent files
vim.keymap.set("n", "<leader>f.", function()
	require("telescope.builtin").oldfiles()
end, { desc = "recent" })
-- find in open buffers
vim.keymap.set("n", "<leader>b", function()
	require("telescope.builtin").buffers()
end, { desc = "Find buffer" })
-- smart open
vim.keymap.set("n", "<leader><leader>", function()
	require("telescope").extensions.smart_open.smart_open({ cwd_only = true, filename_first = false })
end, { desc = "Find buffer" })

-- gitlab links
vim.keymap.set("n", "<leader>gl", ":GetCurrentCommitLink<CR>", { desc = "Gitlab link" })
vim.keymap.set("v", "<leader>gl", ":'<,'>GetCurrentCommitLink<CR>", { desc = "Gitlab link" })

-- Macro
-- play from the next line
vim.keymap.set("n", "Q", "@qj")
-- apply for selection on the visual mode
vim.keymap.set("x", "Q", ":norm @q<CR>")

vim.keymap.set("n", "<leader>n", ":Navbuddy<CR>", { desc = "Navigation buddy" })

vim.keymap.set({ "n", "i", "s" }, "<c-d>", "<c-d>zz")
vim.keymap.set({ "n", "i", "s" }, "<c-u>", "<c-u>zz")

-- tests
vim.keymap.set("n", "<leader>ta", function()
	require("neotest").run.run(vim.fn.getcwd())
end, { desc = "Run all tests" })

vim.keymap.set("n", "<leader>tf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run tests in the file" })

vim.keymap.set("n", "<leader>tr", function()
	require("neotest").run.run()
end, { desc = "Run single test" })

vim.keymap.set("n", "<leader>tt", function()
	require("neotest").summary.toggle()
end, { desc = "Display tests" })

vim.keymap.set("n", "<leader>tO", function()
	require("neotest").output_panel.toggle()
end, { desc = "Toggle Output Panel" })

vim.keymap.set("n", "<leader>to", function()
	require("neotest").output.open({ enter = true, auto_close = true })
end, { desc = "Show Output" })

-- popup doc
vim.keymap.set("n", "<leader>k", function()
	vim.lsp.buf.hover()
end, { desc = "Show documentation" })
