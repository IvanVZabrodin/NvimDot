-- Defines themes (not for colourschemes though, thats done using themify)

---@class Nibble.Crayon: Nibble
local M = {}

---@class Nibble.Crayon.Options.Module
---@field enabled boolean
---@field opts table?
---@field module Nibble.Crayon.Module?

---@class Nibble.Crayon.Options
M.defaults = {
	---@type table<string, Nibble.Crayon.Options.Module>
	modules = {
		["highlight"] = {
			enabled = true
		},
		["border"] = {
			enabled = true
		},
		["lsp"] = {
			enabled = true
		},
		["icon"] = {
			enabled = true
		},
		["stc"] = {
			enabled = true
		}
	},

	---@type string | Nibble.Crayon.Theme
	theme = "alldefaults"
}

-- A crayon module should have its own themes, which can then be set instead of opts

-- Module opts would be like this
---@class Nibble.Crayon.Module.Opts
---@field themed table The options defined by the theme chosen
---@field theme_name string? The name of the theme chosen (unless it is given by a table)
---@field eopts table? The extra unthemed opts

---@class Nibble.Crayon.Theme
---@field name string

---@type table<string, Nibble.Crayon.Theme>
M.themes = {
	alldefaults = { name = "ald" }
}

---@class Nibble.Crayon.Module
---@field default_theme string
---@field themes table
---@field eopts table?
---@field config Nibble.ScheduledLoader
---@field loader Nibble.ScheduledLoader

---@type table<string, { mod: Nibble.Crayon.Module, opt: table }>
local modules = {}

---@type Nibble.ScheduledLoader
local config = {}

---@param module string | Nibble.Crayon.Module
---@param opts table?
---@return Nibble.Crayon.Module, table
local function load_module(module, opts)
	local has_module, mod
	if type(module) == "string" then
		has_module, mod = pcall(require, "good.nibbles.crayon.modules." .. module)
	else
		has_module = true
		mod = module
	end

	---@diagnostic disable-next-line
	local r = has_module and mod or require(module)
	local opt = vim.tbl_deep_extend('force', r.defaults or {}, opts or {})

	modules[module] = { mod = r, opt = opt }

	return r, opt
end

---@param opts Nibble.Crayon.Options
config.strap = function (opts)
	vim.api.nvim_create_augroup("Crayon", { clear = true })

	local loaded = { modules = {} }

	---@type Nibble.Crayon.Theme
	---@diagnostic disable-next-line See https://github.com/LuaLS/lua-language-server/issues/2233
	local theme = ((type(opts.theme) == "string") and M.themes[opts.theme] or opts.theme)

	for name, module in pairs(opts.modules) do
		if module.enabled == true then
			local mod, options = load_module(module.module or name, vim.tbl_deep_extend('force', theme[name] or {}, module.opts or {}))

			if mod.config.strap then
				loaded.modules[name] = mod.config.strap(options)
			end
		end
	end

	return loaded
end

config.load = function (opts)
	local loaded = { modules = {} }

	for name, mod in pairs(modules) do
		if mod.mod.config.load then
			loaded.modules[name] = mod.mod.config.load(mod.opt)
		end
	end

	return loaded
end

config.post = function (opts)
	local loaded = { modules = {} }

	for name, mod in pairs(modules) do
		if mod.mod.config.post then
			loaded.modules[name] = mod.mod.config.post(mod.opt)
		end
	end

	return loaded
end

M.config = config

---@type Nibble.ScheduledLoader
local loader = {}

loader.strap = function (opts)
	local loaded = { modules = {} }

	for name, mod in pairs(modules) do
		if mod.mod.loader.strap then
			loaded.modules[name] = mod.mod.loader.strap(mod.opt)
		end
	end

	return loaded
end

loader.load = function (opts)
	local loaded = { modules = {} }

	for name, mod in pairs(modules) do
		if mod.mod.loader.load then
			loaded.modules[name] = mod.mod.loader.load(mod.opt)
		end
	end

	return loaded
end

loader.post = function (opts)
	local loaded = { modules = {} }

	for name, mod in pairs(modules) do
		if mod.mod.loader.post then
			loaded.modules[name] = mod.mod.loader.post(mod.opt)
		end
	end

	return loaded
end

M.loader = loader

return M
