vim.keymap.set("n", "<leader>wv", function()
	require("telescope._extensions.venom.virtualenvs").virtualenvs()
end, { desc = "[V]irtual Environment" })
