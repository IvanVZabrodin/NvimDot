---@type Nibble.Crayon.Module
local M = {}

---@class Nibble.Crayon.Module.Stc.Options
M.defaults = {
	ft_ignore = { "alpha", "help", "neo-tree" },
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
end

loader.load = function (opts)
	vim.opt.statuscolumn = stcs.inactive

	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "BufWinEnter" }, {
		callback = function (args) update_stcs(opts) end
	})

	-- vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	-- 	callback = function (args)
	-- 		-- print(vim.inspect(args))
	-- 		local bufnr = args.buf
	-- 		local winid = vim.fn.bufwinid(bufnr)
	--
	-- 		if winid == -1 then return end
	--
	-- 		local ft = vim.bo[bufnr].filetype
	-- 		local bt = vim.bo[bufnr].buftype
	--
	-- 		if vim.list_contains(opts.ft_ignore, ft) or vim.list_contains(opts.bt_ignore, bt) then
	-- 			vim.wo[bufnr].statuscolumn = ""
	-- 		else
	-- 			vim.wo[winid].statuscolumn = stcs.inactive
	-- 		end
	-- 	end
	-- })
end

M.loader = loader

return M
