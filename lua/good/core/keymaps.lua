local M = {} -- TODO: Maybe rewrite
local util = require("good.util")

---@diagnostic disable-next-line
table.unpack = table.unpack or unpack

local default_maps = {
	lsp = {
		fullmap = true,
		subleader = ",",

		maps = {
			hover = { "m", fullmap = true },
			definition = "d",
			declaration = "D",
			implementation = "i",
			type_definition = "t",
			references = "r",
			signature_help = "s",
			rename = "R"
		}
	},
	telescope = {
		subleader = "f",

		maps = {
			files = "f",
			grep = "g",
			buffers = "b",
			document_symbols = "s"
		}
	},
	neotree = {
		subleader = "n",

		maps = {
			left = "",
			float = { "\\", fullmap = true }
		}
	}
}

local default_definitions = {
	lsp = {
		icon_layer = "lsp",
		group = { desc = "LSP Actions" },
		opts = { silent = true },
		no_auto_load = true,

		maps = {
			hover = { "<CMD>lua vim.lsp.buf.hover()<CR>", desc = "hover" },
			definition = "<CMD>lua vim.lsp.buf.definition()<CR>",
			declaration = "<CMD>lua vim.lsp.buf.declaration()<CR>",
			implementation = "<CMD>lua vim.lsp.buf.implementation()<CR>",
			type_definition = "<CMD>lua vim.lsp.buf.type_definition()<CR>",
			references = "<CMD>lua vim.lsp.buf.references()<CR>",
			signature_help = "<CMD>lua vim.lsp.buf.signature_help()<CR>",
			rename = "<CMD>lua.lsp.buf.rename()<CR>"
		}
	},
	telescope = {
		icon_layer = "telescope",
		group = { desc = "Telescope Actions" },
		descprompt = "find ",
		opts = { silent = true },

		maps = {
			files = "<CMD>Telescope find_files<CR>",
			grep = { "<CMD>Telescope live_grep<CR>", desc = "live grep" },
			buffers = "<CMD>Telescope buffers<CR>",
			document_symbols = "<CMD>Telescope lsp_document_symbols<CR>"
		}
	},
	neotree = {
		icon_layer = "neotree",
		descprompt = "open neotree ",
		opts = { silent = true },

		maps = {
			left = "<CMD>Neotree filesystem reveal left<CR>",
			float = "<CMD>Neotree filesystem reveal float<CR>"
		}
	}
}

local loaded = {}

local function expand_submap(submap, definition)
	local fl = (submap.fullmap and submap.subleader or ("<leader>" .. submap.subleader))

	local resmaps = {}

	for name, map in pairs(submap.maps) do
		local d = type(definition.maps[name]) == "string" and {definition.maps[name]} or definition.maps[name]
		local m

		if type(map) == "table" then
			m = (map.fullmap and "" or fl) .. map[1]
		else
			m = (fl .. map)
		end

		resmaps[name] = vim.tbl_deep_extend('force', { m, d[1], desc = d.desc or util.get_default_desc(name, definition.descprompt or "show "), icon = util.get_icon(d.icon or (definition.icon_layer .. "." .. name)) }, d.opts or {})
	end

	return { fleader = fl, il = definition.icon_layer, group = definition.group, maps = resmaps, opts = definition.opts or {} }
end

M.load_submap = function (submap, extra_opts)
	local wk = require("which-key")

	local t = { submap.group and { submap.fleader, group = submap.group.desc, icon = util.get_icon(submap.group.icon or (submap.il .. ".main")) } }
	for k, v in pairs(vim.tbl_deep_extend('force', submap.opts, extra_opts or {})) do t[k] = v end
	for _, v in pairs(submap.maps) do table.insert(t, v) end

	wk.add(t)
end

M.load_lsp = function (event)
	vim.keymap.del('n', 'K', { buffer = event.buf })

	M.load_submap(loaded.lsp, { buffer = event.buf })
end

M.load = function ()
	local maps = require("good.options.keymaps")

	local unparsed_maps = vim.tbl_deep_extend('force', default_maps, maps.maps or {})
	local unparsed_defs = vim.tbl_deep_extend('force', default_definitions, maps.definitions or {})
	for k, v in pairs(unparsed_maps) do
		loaded[k] = expand_submap(v, unparsed_defs[k])
		if unparsed_defs[k].no_auto_load ~= true then M.load_submap(loaded[k], {}) end
	end
end

return M
