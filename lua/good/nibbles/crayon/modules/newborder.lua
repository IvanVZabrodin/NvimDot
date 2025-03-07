---@type Nibble.Crayon.Module
local M = {}

M.eopts = {
	borders = {
		-- TODO: Put borders here
	}
}

M.themes = {
	["bordered"] = {
		default = "border"
	}
}

M.default_theme = "bordered"


---@type Nibble.ScheduledLoader
local config = {}

---@param opts Nibble.Crayon.Module.Opts
config.strap = function (opts)
	
end

M.config = config


---@type Nibble.ScheduledLoader
local loader = {}

M.loader = loader

return M
