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

local convert = {
	---@param border Nibble.Crayon.Border
	---@return table
	native = function (border)
		local res = {}

		for _, s in ipairs(border.chars) do
			table.insert(res, { s, border.highlight })
		end

		return res
	end,

	---@param border Nibble.Crayon.Border
	---@return table
	cmp = function (border)
		return {
			border = border.chars,
			winhighlight = "FloatBorder:" .. border.highlight
		}
	end
}

---@class Nibble.Crayon.Border
---@field chars string[]
---@field highlight string

---@param border string | Nibble.Crayon.Border
---@param fmt ("native" | "cmp")?
---@param borders table<string, Nibble.Crayon.Border>
local function get_border(border, fmt, borders)
	fmt = fmt or "native"
	border = borders[border] or border

	---@diagnostic disable-next-line
	return convert[fmt](border)
end

---@type Nibble.ScheduledLoader
local config = {}

---@param opts Nibble.Crayon.Module.Opts
config.strap = function (opts)
	local borders = opts.eopts.borders
	local themed = opts.themed

	return {
		lsp_native = get_border(themed.lsp or themed.default, "native", borders),
	}
end

M.config = config


---@type Nibble.ScheduledLoader
local loader = {}

M.loader = loader

return M
