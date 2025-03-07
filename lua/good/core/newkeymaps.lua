local M = {}

local example_maps = {
	["name"] = {
		{
			["name"] = { "m", "<CMD>lua print('hi')<CR>)", fullmap = true }
		},
		opts = { mode = "n" },
		group = { "f", fullmap = false, icon = "j", desc = "defaults to the key or nil" }, -- Actually define as a group
	}
}

M.expand_keymap = function (map, leader, opts)
	
end

M.expand_groupmap = function (map, leader, key) -- We want this to return { (map.fullmap and "" or leader) .. map[1], map[2], group = map.desc or key, icon = map.icon }
	local keymap = (map.fullmap and "" or leader) .. map[1]
	local group = map.desc or key
	return { keymap, map[2], group = group, icon = map.icon, unpack(map.opts or {}) }
end

M.expand_submap = function (map, key, leader)
	local resmaps = map.opts or {}

	if type(map[1]) == "table" then -- It is a grouped map
		if map.group then
			table.insert(resmaps, M.expand_groupmap(map.group, leader, key))
		end

		vim.list_extend(resmaps, M.expand_submap(map[1]))
	end

	return resmaps
end

M.test = function ()
	local res = M.expand_submap(example_maps["name"], "name", "<leader>", {})
	print(vim.inspect(res))
end

return M
