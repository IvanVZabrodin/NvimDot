---@type Nibble.Crayon.Module
local M = {}

local use_handler_opts = require("good.nibbles.crayon.modules.lsp").use_handler_opts

---@class Nibble.Crayon.Module.Border.Options
---@field default string? The default border to use in case of no override
---@field native string?
---@field cmp string?
---@field wk string?
---@field neotree string?
---@field dressing string?
---@field no_override_lsp boolean?
---@field lsp_handlers table? The lsp handlers to override
M.defaults = {
	default = "rounded",
	lsp_handlers = { "hover", "signature_help" }
}

---@type Nibble.ScheduledLoader
local config = {}

---@type table<string, fun(border: Nibble.Crayon.Module.Border): table>
local convert = {
	native = function (border)
		local res = {}

		for _, s in ipairs(border.chars) do
			table.insert(res, { s, border.highlight })
		end

		return res
	end,

	cmp = function (border)
		return {
			border = border.chars,
			winhighlight = "FloatBorder:" .. border.highlight .. ",CursorLine:Visual,Search:None"
		}
	end
}

---@class Nibble.Crayon.Module.Border
---@field chars table<string>
---@field highlight string

---@type table<string, Nibble.Crayon.Module.Border>
local borders = {
	rounded = {
		chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		highlight = "GoodBorder", -- TODO: Find a way to use loaded.crayon.modules.highlight.border instead (but its loaded also during strap)
	},
	none = {
		chars = { " ", " ", " ", " ", " ", " ", " ", " " },
		highlight = "Normal"
	}
}

local function get_border(border, default)
	local b = border or default
	return type(b) == "table" and b or borders[b]
end

---@param opts Nibble.Crayon.Module.Border.Options
config.strap = function (opts)
	local loaded = {
		native = convert.native(get_border(opts.native, opts.default)),
		cmp = convert.cmp(get_border(opts.cmp, opts.default)),
		wk = convert.native(get_border(opts.wk, opts.default)),
		dressing = convert.native(get_border(opts.dressing, opts.default)),
		neotree = convert.native(get_border(opts.neotree, opts.default))
	}

	return loaded
end

M.config = config

---@type Nibble.ScheduledLoader
local loader = {}

loader.post = function (opts)
	if opts.no_override_lsp ~= true then
		local native_border = require("good.nibbles").loaded.crayon.modules.border.native
		for _, h in ipairs(opts.lsp_handlers) do use_handler_opts(h, { border = native_border }) end
	end
end

M.loader = loader

return M
