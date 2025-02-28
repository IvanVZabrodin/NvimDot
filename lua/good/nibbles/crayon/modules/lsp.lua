---@class Nibble.Crayon.Module
local M = {}

---@class Nibble.Crayon.Module.Lsp.Options
M.defaults = {

}

local handlers = {}

local function update_handler(handler)
	local h = handlers[handler]

	local newhand = function (opts)
		opts = opts or {}
		return h.original(vim.tbl_deep_extend('force', h.opts, opts))
	end

	return newhand
end

M.use_handler_opts = function (handler, opts)
	if handlers[handler] then
		for k, v in pairs(opts) do handlers[handler].opts[k] = v end
	else
		handlers[handler] = { original = vim.lsp.buf[handler], opts = opts }
	end

	vim.lsp.buf[handler] = update_handler(handler)
end


---@type Nibble.ScheduledLoader
local config = {}

M.config = config

---@type Nibble.ScheduledLoader
local loader = {}

M.loader = loader

return M
