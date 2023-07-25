local helpers = require("utils.helpers")
if not helpers.exists("cmp") then
	return
end

local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip/loaders/from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })

-- for "super tab" below
local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local kind_icons = {
	Text = "  ",
	Method = "  ",
	Function = "  ",
	Constructor = "  ",
	Field = "  ",
	Variable = "  ",
	Class = "  ",
	Interface = "  ",
	Module = "  ",
	Property = "  ",
	Unit = "  ",
	Value = "  ",
	Enum = "  ",
	Keyword = "  ",
	Snippet = "󰃐  ",
	Color = "  ",
	File = "  ",
	Reference = "  ",
	Folder = "  ",
	EnumMember = "  ",
	Constant = "  ",
	Struct = "  ",
	Event = "  ",
	Operator = "  ",
	TypeParameter = "  ",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		["<C-k>"] = cmp.mapping.select_prev_item(), -- move up in the completions menu
		["<C-j>"] = cmp.mapping.select_next_item(), -- move down in the completions menu
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }), -- scroll up in the snippet screen
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }), -- scroll down in the snippets screen
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }), -- launch completions menu without typing
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({ -- exit the completions menu
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		-- super tab, move through menu or move through snippets
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif check_backspace() then
				fallback()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},
	-- formatting = {
	-- 	fields = { "kind", "abbr", "menu" },
	-- 	format = function(entry, vim_item)
	-- 		-- Kind icons
	-- 		vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
	-- 		-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
	-- 		vim_item.menu = ({
	-- 			nvim_lsp = "[LSP]",
	-- 			nvim_lua = "[Lua]",
	-- 			luasnip = "[Snippet]",
	-- 			buffer = "[Buffer]",
	-- 			path = "[Path]",
	-- 		})[entry.source.name]
	-- 		return vim_item
	-- 	end,
	-- },
	formatting = {
		fields = { "kind", "abbr" },
		format = function(_, vim_item)
			vim_item.kind = kind_icons[vim_item.kind] or ""
			return vim_item
		end,
	},
	-- order matters, it will appear in that order in the completion menu (using its own custom weighting system)
	sources = {
		{ name = "nvim_lsp_signature_help" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "buffer" },
		{ name = "luasnip" },
		{ name = "path" },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	window = {
		documentation = {
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
		},
		completion = {
			winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
		},
	},
	experimental = {
		ghost_text = false, -- virtual text that spells out the remaining chars for a completion
		native_menu = false,
	},
})
