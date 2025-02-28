local M = {}

M.components = {}

M.schedule = {}

local function get_calls(component)
	if type(component) ~= "table" then return { component } end
	if #component > 0 then return component end
	return component
end

local function apply_opt(func, optser)
	return function (opts) return func(optser(opts)) end
end

M.register = function (schedule)
	local res = {}

	for _, comp in ipairs(schedule) do
		if type(comp) == "function" then
			table.insert(res, comp)
		elseif type(comp) == "string" then
			vim.list_extend(res, get_calls(M.components[comp]))
		elseif comp.component then
			local c = type(comp.component) == "string" and M.components[comp.component] or comp.component
			local calls = get_calls(c)
			local items = comp.items or { 1 }
			for _, i in ipairs(items) do
				if type(calls[i]) == "table" then
					for _, f in pairs(calls[i]) do
						table.insert(res, comp.optser and apply_opt(f, comp.optser) or f)
					end
				else
					table.insert(res, comp.optser and apply_opt(calls[i], comp.optser) or calls[i])
				end
			end
		else
			vim.notify("Idk what to do with " .. vim.inspect(comp), vim.log.levels.ERROR)
		end
	end

	M.schedule = res
end

M.load = function (opts)
	for _, c in ipairs(M.schedule) do
		c(opts)
	end
end

return M
