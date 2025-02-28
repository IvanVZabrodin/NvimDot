local M = {}

M.subindex = function (t, inds)
	local c = t

	for _, i in ipairs(inds) do
		c = c[i] or {}
	end

	return c
end

M.Set = function (v)
	local set = {}
	for _, l in ipairs(v) do set[l] = true end
	return set
end

return M
