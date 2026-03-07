local M = {}

---@class Good.Options
local default_options = {
	nibbles = require("good.nibbles").defaults,
	tabwidth = 4,
	greeter_theme = "dashboard", -- See alpha themes
}

---@type Good.Options
M.options = nil

M.load = function (opts)
	M.options = vim.tbl_deep_extend('force', default_options, opts)
	return M.options
end

M.constants = function (opts)
	local set = vim.opt

	set.tabstop = opts.tabwidth
	set.softtabstop = opts.tabwidth
	set.shiftwidth = opts.tabwidth

	set.foldmethod = "expr"
	set.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	set.foldtext = ""
	set.foldlevel = 99
	set.foldnestmax = 4
	set.foldcolumn = "1"

	set.clipboard = "unnamedplus"

	vim.o.formatexpr = "v:lua.require('conform').formatexpr()"

	vim.g.python3_host_prog = "C:/Users/i_zabrodin23/Apps/python3.13/python.exe"
end

return M
