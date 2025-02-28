local M = {}

M.build = require("good.util.build")
M.containers = require("good.util.containers")
M.convert = require("good.util.convert")

M.get_icon = function (icon)
	if type(icon) == "string" then
		if #icon > 2 then
			return M.containers.subindex(require("good.nibbles").loaded.crayon.modules.icon, M.convert.table.iterator(icon:gmatch("[^.]+")))
		end
		return icon
	end
	return icon
end

M.get_default_desc = function (name, probable_prompt)
	return (probable_prompt or "") .. name:gsub("_", " ")
end

return M
