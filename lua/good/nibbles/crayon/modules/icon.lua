---@class Nibble.Crayon.Module
local M = {}

---@class Nibble.Crayon.Module.Icon.Options
M.defaults = {

}

---@type Nibble.ScheduledLoader
local config = {}

config.strap = function (opts)
		return {}
end

M.config = config

---@type Nibble.ScheduledLoader
local loader = {}

M.loader = loader

return M
