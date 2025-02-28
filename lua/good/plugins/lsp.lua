return {
	{
		"williamboman/mason.nvim",
		dependencies = { "mason-org/mason-registry" },
		cmd = { "Mason" },
		opts = {},
	},
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter" },
		dependencies = { "onsails/lspkind.nvim" },
		config = function ()
			local cmp = require("cmp")
			local lspkind = require("lspkind")

			local cmp_border = cmp.config.window.bordered(require("good.nibbles").loaded.crayon.modules.border.cmp)

			cmp.setup {
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

				performance = {
					fetching_timeout = 1,
				},

				formatting = {
					format = lspkind.cmp_format {
						mode = "symbol"
					}
				}
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
					end
				}
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
}
