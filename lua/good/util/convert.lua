local converters = {}

converters.border = {
	native = function (border)
		local res = {}

		for _, v in ipairs(border.border) do
			table.insert(res, { v, border.highlight })
		end

		return res
	end,

	cmp = function (border)
		return {
			border = border.border,
			winhighlight = "FloatBorder:" .. border.highlight .. ",CursorLine:Visual,Search:None"
		}
	end,
}

converters.language = { -- Uses lspconfig naming system
	mason = function (lang)
		local mason_mappings = require("mason-lspconfig").get_mappings()
		local lsp = mason_mappings.lspconfig_to_mason[lang]
		return lsp
	end,

	treesitter = function (lang)
		local lspconfig = require("lspconfig")
		local fts = lspconfig[lang].document_config.default_config.filetypes
		local parsers = require("nvim-treesitter.parsers")

		local langs = {}

		for _, f in ipairs(fts) do
			table.insert(langs, parsers.ft_to_lang(f))
		end

		return langs
	end,

	lspconfig = function (lang) -- From mason, treesitter not worth it
		local mason_mappings = require("mason-lspconfig").get_mappings()
		local lsp = mason_mappings.mason_to_lspconfig[lang]
		return lsp
	end
}

converters.table = {
	iterator = function (it)
		local res = {}

		for v in it do
			table.insert(res, v)
		end

		return res
	end
}

return converters
