---@type Nibble.Crayon.Module
local M = {}

-- TODO: When closing a help window (like a floating info), it seems that the enter into the float is called, but the enter back into the original window does not get autocommanded

---@class Nibble.Crayon.Module.Stc.Options
M.defaults = {
	ft_ignore = {},
	bt_ignore = {}
}

local stcs = {
	active = [[ %s%C%= %#GoodOtherLine#%{v:relnum?v:relnum:''}%#GoodCurrentLine#%{v:relnum?'':v:lnum}%#StatusColumn# ]],
	inactive = [[ %s%C%= %#GoodOtherLine#%{v:lnum}%#StatusColumn# ]]
}

local update_stcs = function (opts)
	local active = vim.api.nvim_get_current_win()

	for _, w in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_config(w).relative == "" then
			local bufnr = vim.fn.winbufnr(w)
			local ft = vim.bo[bufnr].filetype
			local bt = vim.bo[bufnr].buftype

			if vim.list_contains(opts.ft_ignore, ft) or vim.list_contains(opts.bt_ignore, bt) then
				vim.wo[w].statuscolumn = ""
			else
				vim.wo[w].statuscolumn = w == active and stcs.active or stcs.inactive
			end
		end
	end
end

---@type Nibble.ScheduledLoader
local config = {}

M.config = config

---@type Nibble.ScheduledLoader
local loader = {}

loader.strap = function (opts)
	vim.opt.relativenumber = true
	vim.opt.signcolumn = "yes"
	vim.opt.numberwidth = 7
end

loader.load = function (opts)
	vim.opt.statuscolumn = stcs.inactive

	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "BufWinEnter", "WinClosed" }, {
		callback = function (args) update_stcs(opts) end
	})

	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function (args) vim.defer_fn(function () update_stcs(opts) end, 25) end
	})
end

M.loader = loader

return M
