---@class Nibble.ScheduledLoader
---@field strap fun(opts: table): (table?)?
---@field load fun(opts: table): (table?)?
---@field post fun(opts: table): (table?)?

---@class Nibble
---@field defaults table
---@field config Nibble.ScheduledLoader
---@field loader Nibble.ScheduledLoader


local M = {}

---@class Nibble.Options.Nibble
---@field enabled boolean
---@field opts table
---@field module Nibble?

---@alias Nibble.Options table<string, Nibble.Options.Nibble>

---@type Nibble.Options
M.defaults = {
	crayon = {
		enabled = true,
		opts = require("good.nibbles.crayon").defaults
	}
}

---@class Nibble.Loaded
---@field crayon table?
M.loaded = {}

local nibbles = {}

---@type Nibble.ScheduledLoader
local config = {}

---@param opts Nibble.Options
config.strap = function (opts)
	for name, nibble in pairs(opts) do
		if nibble.enabled ~= false then
			local mod = nibble.module or require("good.nibbles." .. name)

			nibbles[name] = mod
			M.loaded[name] = mod.config.strap(nibble.opts) or {}
		end
	end
end

config.load = function (opts)
	for name, nibble in pairs(nibbles) do
		M.loaded[name] = vim.tbl_deep_extend('force', M.loaded[name], nibble.config.load(opts[name].opts) or {})
	end
end

config.post = function (opts)
	for name, nibble in pairs(nibbles) do
		M.loaded[name] = vim.tbl_deep_extend('force', M.loaded[name], nibble.config.post(opts[name].opts) or {})
	end
end

M.config = config

---@type Nibble.ScheduledLoader
local loader = {}

loader.strap = function (opts)
	for name, nibble in pairs(nibbles) do
		M.loaded[name] = vim.tbl_deep_extend('force', M.loaded[name], nibble.loader.strap(opts[name].opts))
	end
end

loader.load = function (opts)
	for name, nibble in pairs(nibbles) do
		M.loaded[name] = vim.tbl_deep_extend('force', M.loaded[name], nibble.loader.load(opts[name].opts))
	end
end

loader.post = function (opts)
	for name, nibble in pairs(nibbles) do
		M.loaded[name] = vim.tbl_deep_extend('force', M.loaded[name], nibble.loader.post(opts[name].opts))
	end
end

M.loader = loader

return M
