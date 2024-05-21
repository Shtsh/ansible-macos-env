-- No example configuration was found for this plugin.
--
-- For detailed information on configuring this plugin, please refer to its
-- official documentation:
--
--   https://github.com/nvim-lualine/lualine.nvim
--
-- If you wish to use this plugin, you can optionally modify and then uncomment
-- the configuration below.

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "Shtsh/neoconf-venom.nvim", "linrongbin16/lsp-progress.nvim" },
	config = function()
		local lazy_status = require("lazy.status")
		local venom = require("venom")
		require("lsp-progress").setup({
			client_format = function(client_name, spinner, series_messages)
				if #series_messages == 0 then
					return nil
				end
				return {
					name = client_name,
					body = spinner .. " " .. table.concat(series_messages, ", "),
				}
			end,
			format = function(client_messages)
				--- @param name string
				--- @param msg string?
				--- @return string
				local function stringify(name, msg)
					return msg and string.format("%s %s", name, msg) or name
				end

				local sign = "" -- nf-fa-gear \uf013
				local lsp_clients = vim.lsp.get_clients()
				local messages_map = {}
				for _, climsg in ipairs(client_messages) do
					messages_map[climsg.name] = climsg.body
				end

				if #lsp_clients > 0 then
					table.sort(lsp_clients, function(a, b)
						return a.name < b.name
					end)
					local builder = {}
					for _, cli in ipairs(lsp_clients) do
						if type(cli) == "table" and type(cli.name) == "string" and string.len(cli.name) > 0 then
							if messages_map[cli.name] then
								table.insert(builder, stringify(messages_map[cli.name]))
								-- table.insert(builder, stringify(cli.name, messages_map[cli.name]))
							else
								-- table.insert(builder, stringify(cli.name))
							end
						end
					end
					if #builder > 0 then
						return table.concat(builder, ", ")
						-- return sign .. " " .. table.concat(builder, ", ")
					end
				end
				return ""
			end,
		})
		require("lualine").setup({
			options = {
				theme = "catppuccin",
				component_separators = " ",
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_c = {
					function()
						return require("lsp-progress").progress()
					end,
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat" },
					{ venom.statusline },
					{ "filetype" },
				},
			},
		})

		-- listen lsp-progress event and refresh lualine
		vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			group = "lualine_augroup",
			pattern = "LspProgressStatusUpdated",
			callback = require("lualine").refresh,
		})
	end,
}
