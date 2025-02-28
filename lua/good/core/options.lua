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
end

return M
