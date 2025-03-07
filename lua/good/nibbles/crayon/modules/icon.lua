---@class Nibble.Crayon.Module
local M = {}

---@class Nibble.Crayon.Module.Icon.Options
M.defaults = {
	diagnostics = {
		info = " ",
		hint = " ",
		warn = " ",
		error = " "
	}
}

---@type Nibble.ScheduledLoader
local config = {}

config.strap = function (opts)
	return vim.tbl_deep_extend('force', M.defaults, opts)
end

M.config = config

---@type Nibble.ScheduledLoader
local loader = {}

M.loader = loader

return M
