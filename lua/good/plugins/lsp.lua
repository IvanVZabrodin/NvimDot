return {
	{
		"williamboman/mason.nvim",
		dependencies = { "mason-org/mason-registry" },
		cmd = { "Mason" },
		opts = function ()
			local mason_border = require("good.nibbles").loaded.crayon.modules.border.mason
			return {
				ui = {
					border = mason_border
				}
			}
		end
	},
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter" },
		dependencies = { "onsails/lspkind.nvim" },
		config = function ()
			local cmp = require("cmp")
			local context = require("cmp.config.context")
			local lspkind = require("lspkind")

			local cmp_border = cmp.config.window.bordered(require("good.nibbles").loaded.crayon.modules.border.cmp)

			cmp.setup {
				enabled = function ()
					return not (context.in_syntax_group("Comment") or context.in_syntax_group("String"))
				end,

				sources = {
					{ name = "lazydev", group_index = 0 },
					{ name = "nvim_lsp" },
				},

				preselect = cmp.PreselectMode.None,

				mapping = cmp.mapping.preset.insert {
					["<CR>"] = cmp.mapping.confirm { select = false },
				},

				snippet = {
					expand = function (args)
						vim.snippet.expand(args.body)
					end,
				},

				window = {
					completion = cmp_border,
					documentation = cmp_border,
				},

				completion = {
					completeopt = 'menu,menuone,noinsert'
				},

				view = {
					docs = { auto_open = true },
				},

				---@diagnostic disable
				performance = {
					fetching_timeout = 1,
				},
				---@diagnostic enable

				---@diagnostic disable
				formatting = {
					format = lspkind.cmp_format {
						mode = "symbol"
					}
				},
				---@diagnostic enable

				-- experimental = {
				-- 	ghost_text = true
				-- }
			}
		end
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		lazy = vim.fn.argc(-1) == 0,
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function ()
			local lsp_defaults = require("lspconfig").util.default_config

			lsp_defaults.capabilities = vim.tbl_deep_extend(
				'force',
				lsp_defaults.capabilities,
				require("cmp_nvim_lsp").default_capabilities()
			)

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = require("good.core.keymaps").load_lsp
			})

			require("mason")

			require("mason-lspconfig").setup {
				handlers = {
					function (server_name)
						require("lspconfig")[server_name].setup {}
					end,

					["basedpyright"] = function ()
						require("lspconfig").basedpyright.setup {
							settings = {
								basedpyright = {
									analysis = {
										typeCheckingMode = "standard"
									}
								}
							}
						}
					end
				},
				ensure_installed = {},
				automatic_installation = true
			}
		end
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = { { "nvim-treesitter/nvim-treesitter-textobjects" } },
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		lazy = vim.fn.argc(-1) == 0,
		main = "nvim-treesitter.configs"
	},
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = { chunk = { enable = true } }
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"ray-x/lsp_signature.nvim",
		event = { "InsertEnter" },
		opts = function ()
			local border = require("good.nibbles").loaded.crayon.modules.border.native

			return { border = border }
		end
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre", "BufNewFile" },
		cmd = { "ConformInfo" },
		opts = { format_on_save = {} }
	},
	{
		"mimikun/mason-conform.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "ConformInstall", "ConformUninstall" },
		lazy = vim.fn.argc(-1) == 0,
		opts = {
			handlers = {
				function (formatter)
					require("conform").formatters_by_ft = require("mason-conform").formatter_handler(formatter)
				end
			}
		}
	},
	-- {
	-- 	"mfussenegger/nvim-dap",
	-- 	cmd = "Dap",
	-- 	opts = {}
	-- }
}
