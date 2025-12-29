---@type Nibble.Crayon.Module
local M = {}

---@class Nibble.Crayon.Module.Highlight.Options
M.defaults = {
	border = { name = "GoodBorder", definition = { link = "FloatBorder" } },
	mainline = { name = "GoodCurrentLine", definition = { link = "CursorLineNr" } },
	otherline = { name = "GoodOtherLine", definition = { link = "LineNr" } },
	alphaheader = { name = "AlphaHeader", definition = { link = "DiagnosticWarn" }, change = true }
}

local changes = {}

---@type Nibble.ScheduledLoader
local config = {}

---@param opts Nibble.Crayon.Module.Highlight.Options
config.strap = function (opts)
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = function (args)
			for _, def in pairs(opts) do
				vim.api.nvim_set_hl(0, def.name, def.definition)
			end
		end
	})
end

M.config = config

---@type Nibble.ScheduledLoader
local loader = {}

loader.post = function (opts)

end

M.loader = loader

return M
