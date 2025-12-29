local M = {}

M.statuscolumn = function (opts) -- TODO: make better, custom modules, etc...
	local res = [[]]

	local fold = opts.show_fold and "%#BuiFold#%C" or ""
	local sign = opts.show_sign and "%#BuiSign#%s" or ""
	local num

	if opts.number == "relc" then
		num = [[%#BuiRelativeLine#%{v:relnum?v:relnum:''}%#BuiCurrentLine#%{v:relnum?'':v:lnum}]]
	else
		num = [[%#BuiCurrentLine#%l]]
	end

	local modules = { fold = fold, sign = sign, number = num }
	for _, module in ipairs(opts.modules) do
		res = res .. modules[module]
	end

	return res .. (opts.postprompt or "")
end

return M
