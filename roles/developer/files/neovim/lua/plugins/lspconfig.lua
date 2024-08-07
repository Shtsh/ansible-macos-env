-- autocommands to run on attach
local function attach(event)
	vim.lsp.inlay_hint.enable()
	-- borders for hover popup
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	local client = vim.lsp.get_client_by_id(event.data.client_id)

	-- The following two autocommands are used to highlight references of the
	-- word under your cursor when your cursor rests there for a little while.
	--    See `:help CursorHold` for information about when this is executed
	--
	-- When you move your cursor, the highlights will be cleared (the second autocommand).
	if client and client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = event.buf,
			callback = vim.lsp.buf.document_highlight,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = event.buf,
			callback = vim.lsp.buf.clear_references,
		})
	end
end

return {
	"neovim/nvim-lspconfig",
	opts = {
		inlay_hints = { enabled = true },
		event = { "BufReadPre", "BufNewFile" },
	},
	dependencies = {
		{
			"SmiteshP/nvim-navbuddy",
			dependencies = {
				"SmiteshP/nvim-navic",
				"MunifTanjim/nui.nvim",
			},
			opts = { window = { size = "98%" }, lsp = { auto_attach = true } },
		},
		{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
		{ "Shtsh/neoconf-venom.nvim" },
		"nvim-treesitter/nvim-treesitter",
		{ "folke/neodev.nvim", opts = {} },
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		require("neoconf").setup()
		require("neodev").setup({ library = { plugins = { "neotest" }, types = true } })

		-- Servers configuration
		local servers = {
			basedpyright = {
				settings = {
					basedpyright = {
						typeCheckingMode = "all",
						deprecateTypingAliases = false,
						analysis = {
							diagnosticSeverityOverrides = {
								reportAny = false,
								repoortDeprecated = "warning",
								reportImplicitOverride = false,
								reportImplicitStringConcatenation = false,
								reportMissingParameterType = "warning",
								reportMissingSuperCall = false,
								reportMissingTypeStubs = false,
								reportUndefinedVariable = false,
								reportUnknownArgumentType = false,
								reportUnknownMemberType = false,
								reportUnknownParameterType = false,
								reportUnknownVariableType = false,
								reportUnusedCallResult = false,
							},
						},
					},
				},
			},
			rust_analyzer = {
				handlers = {
					-- Workaround to refresh hints in open part of buffer
					-- otherwise some are node displayed
					-- Learn from rust-tools.nvim
					["experimental/serverStatus"] = function()
						-- First, toggle disable because bufstate.applied
						-- prevents vim.lsp.inlay_hint(bufnr, true) from refreshing.
						-- Therefore, we need to clear bufstate.applied.
						vim.lsp.inlay_hint.enable(false)
						-- toggle enable
						vim.lsp.inlay_hint.enable(true)
					end,
				},
			},
			lua_ls = {},
			ansiblels = {
				filetypes = { "yaml.ansible" },
				root_dir = require("lspconfig.util").root_pattern("ansible.cfg", ".ansible-lint", "inventory"),
			},
			puppet = {
				cmd = { os.getenv("HOME") .. "/.local/puppet-editor-services/puppet-languageserver", "--stdio" },
			},
		}

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = true,
			lineFoldingOnly = false,
		}

		local lspconfig = require("lspconfig")
		for server, conf in pairs(servers) do
			vim.tbl_extend("force", conf, {
				capabilities = capabilities,
			})

			lspconfig[server].setup(conf)
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = attach,
		})
		-- LSP servers and clients are able to communicate to each other what features they support.
	end,
}
