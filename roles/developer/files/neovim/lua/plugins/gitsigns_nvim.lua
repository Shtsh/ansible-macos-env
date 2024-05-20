-- No example configuration was found for this plugin.
--
-- For detailed information on configuring this plugin, please refer to its
-- official documentation:
--
--   https://github.com/lewis6991/gitsigns.nvim
--
-- If you wish to use this plugin, you can optionally modify and then uncomment
-- the configuration below.

return {
	-- "lewis6991/gitsigns.nvim"
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		current_line_blame = false,
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			-- Navigation
			-- map("n", "]h", gs.next_hunk, "Next Hunk")
			-- map("n", "[h", gs.prev_hunk, "Prev Hunk")
			-- -- map("n", "]c", function()
			-- 	if vim.wo.diff then
			-- 		vim.cmd.normal({ "]c", bang = true })
			-- 	else
			-- 		gs.nav_hunk("next")
			-- 	end
			-- end)
			--
			-- map("n", "[c", function()
			-- 	if vim.wo.diff then
			-- 		vim.cmd.normal({ "[c", bang = true })
			-- 	else
			-- 		gs.nav_hunk("prev")
			-- 	end
			-- end)
			-- -- Actions
			map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
			map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
			map("v", "<leader>gs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Stage hunk")
			map("v", "<leader>gr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Reset hunk")

			map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
			map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")

			map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")

			map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")

			map("n", "<leader>gb", function()
				gs.blame_line({ full = true })
			end, "Blame line")
			map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle line blame")

			map("n", "<leader>gd", gs.diffthis, "Diff this")
			map("n", "<leader>gD", function()
				gs.diffthis("~")
			end, "Diff this ~")
			-- Text object
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
		end,
	},
}
