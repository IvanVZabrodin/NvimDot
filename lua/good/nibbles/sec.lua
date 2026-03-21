---@class Nibble.Sec : Nibble
local M = {}

M.defaults = {
	total_size = 40,
	level_diff = 5
}

---@type Nibble.ScheduledLoader
local config = {}

config.strap = function (opts)
	return opts
end

config.post = function (opts)
	return opts
end

config.load = function (opts)
	return opts
end

M.config = config


---@type Nibble.ScheduledLoader
local loader = {}

---comment
---@param opts vim.api.keyset.create_user_command.command_args
local function secmain(opts, upts)
	local val = ""
	local len = upts.total_size
	local level = 1

	local a = vim.split(opts.args, " ")

	if #a == 0 then
		val = vim.fn.input("Title: ")
	elseif #a == 1 then
		val = a[1]
	else
		if tonumber(a[1]) ~= nil then
			level = tonumber(a[1])
			val = a[2]
			if #a == 3 then
				len = tonumber(a[3])
			end
		else
			val = a[1]
			if #a == 2 then
				len = tonumber(a[2])
			end
		end
		if val == "" then
			val = vim.fn.input("Title: ")
		end
	end

	local cstr = type(vim.bo.comments) == "table" and vim.bo.comments[1] or vim.bo.comments
	local ld = (level - 1) * upts.level_diff
	local dlen = math.floor((len - #val - 2 - ld) / 2)
	local dlen2 = math.ceil((len - #val - 2 - ld) / 2)
	local l1 = string.rep("-", dlen)
	local l2 = string.rep("-", dlen2)
	local s = string.rep(" ", ld) .. l1 .. " " .. val .. " " .. l2
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))

	vim.api.nvim_buf_set_lines(0, row - 1, row - 1, true, { string.format(vim.bo.commentstring, " " .. s) })
end

loader.load = function (opts)
	vim.api.nvim_create_user_command("Sec", function(uopts) secmain(uopts, opts) end, {
		nargs = "*"
	})
	return opts
end
loader.post = function (opts)
	return opts
end

loader.strap = function (opts)
	return opts
end

M.loader = loader

return M
