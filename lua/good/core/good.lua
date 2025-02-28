-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

local nibbles = require("good.nibbles")

local keymaps = require("good.core.keymaps")
local options = require("good.core.options")

local startup = require("good.core.startup")

local function lazystart(_)
	require("lazy").setup {
		import = "good.plugins",
		checker = { enabled = true },
	}
end

startup.components = {
	nibbles = {
		strap = { nibbles.config.strap, nibbles.loader.strap },
		load = { nibbles.config.load, nibbles.loader.load },
		post = { nibbles.config.post, nibbles.loader.post }
	},
}

startup.register {
	{ component = "nibbles", items = { "strap" }, optser = function (opts) return opts.nibbles end },
	lazystart,
	options.constants,
	{ component = "nibbles", items = { "load" }, optser = function (opts) return opts.nibbles end },
	keymaps.load,
	{ component = "nibbles", items = { "post" }, optser = function (opts) return opts.nibbles end }
}

startup.load(options.load(require("good.options.options")))
