return {
	{
		"LmanTW/themify.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			"catppuccin/nvim",
			"folke/tokyonight.nvim",
			"rose-pine/neovim",
			"rebelot/kanagawa.nvim"
		}
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function ()
			local wk = require("which-key")
			local wk_border = require("good.nibbles").loaded.crayon.modules.border.wk

			wk.setup {
				preset = "helix",

				win = {
					border = wk_border
				}
			}
		end
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			{ "linrongbin16/lsp-progress.nvim", opts = {} }
		},
		opts = {
			options = {
				ignore_focus = { "neo-tree", "help", "trouble", "alpha" },
			},
			sections = {
				lualine_c = {
					function ()
						return require("lsp-progress").progress()
					end
				}
			}
		}
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		-- config = function ()
		-- 	local telescope = require("telescope")
		-- 	telescope.setup {}
		--
		-- 	telescope.load_extension("projects")
		-- end
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		event = "VeryLazy",
		cmd = "Neotree",
		lazy = vim.fn.argc(-1) == 0,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim"
		},
		opts = function ()
			local neotree_border = require("good.nibbles").loaded.crayon.modules.border.neotree
			return {
				popup_border_style = neotree_border,
				filesystem = {
					filtered_items = {
						visible = true
					}
				}
			}
		end
	},
	{
		"stevearc/dressing.nvim",
		lazy = false,
		opts = function ()
			local dressing_border = require("good.nibbles").loaded.crayon.modules.border.dressing
			return {
				input = { border = dressing_border } -- TODO: maybe add for select too
			}
		end
	},

	-- {
	-- 	"nvim-pack/nvim-spectre",
	-- 	opts = {}
	-- },
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {}
	},
	{
		"ahmedkhalf/project.nvim",
		lazy = false,
		main = "project_nvim"
	},
	{
		"goolord/alpha-nvim",
		cmd = "Alpha", -- TODO: Change, bc I didnt actually check the command
		lazy = vim.fn.argc(-1) ~= 0,
		opts = function ()
			return require("alpha.themes.dashboard").config
		end
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		cmd = "Gitsigns",
		opts = {}
	}
}
