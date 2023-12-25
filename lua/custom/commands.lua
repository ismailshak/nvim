local api = require("utils.api")
local settings = require("custom.settings")
local highlight = require("custom.highlights")

local CUSTOM_GROUP_ID = vim.api.nvim_create_augroup("ShakCommands", { clear = true })

-- USER COMMANDS --

vim.api.nvim_create_user_command("ToggleBackground", api.toggle_bg, {})

-- AUTOCOMMANDS --

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	group = CUSTOM_GROUP_ID,
	callback = function()
		api.save_colorscheme()
		highlight.set_custom_highlights()
	end,
})

-- Override highlight groups for substrata (installed via plugin manager
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "substrata",
	group = CUSTOM_GROUP_ID,
	callback = function()
		vim.g.substrata_italic_comments = false

		-- Override floating window colors
		api.hi("NormalFloat", { link = "Normal" })
		api.hi("FloatBorder", { link = "Normal" })
	end,
})

-- Override highlight groups for nord (/colors/nord.vim)
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "nord",
	group = CUSTOM_GROUP_ID,
	callback = function()
		vim.g.nord_italic = false
		vim.g.nord_uniform_diff_background = 1
		vim.g.nord_bold = 0
	end,
})

-- Override highlight groups for iceberg (/colors/iceberg.vim)
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "iceberg",
	group = CUSTOM_GROUP_ID,
	callback = function()
		-- Disabling all semantic highlights for iceberg
		-- (I didn't like how rust highlighting looked compared to default)
		-- :h lsp-semantic-highlight
		for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
			vim.api.nvim_set_hl(0, group, {})
		end

		--------------------------------
		-- Global highlight overrides --
		--------------------------------

		-- Override floating window colors
		api.hi("NormalFloat", { link = "Normal" })
		api.hi("FloatBorder", { link = "Normal" })

		---------------------------------
		-- Dynamic highlight overrides --
		---------------------------------

		if settings.get().background == "dark" then
			-- Override syntax colors
			api.hi("NoneText", { fg = "#3f4660" }) -- Virtual text
			api.hi("Type", { ctermfg = 110, fg = "#a093c7" })
			api.hi("Keyword", { ctermfg = 110, fg = "#84a0c6" })
			api.hi("TSFunction", { ctermfg = 252, fg = "#b4be82" })
			api.hi("Identifier", { link = "TSVariable" })
			api.hi("TSConstructor", { link = "TSFunction" })
			api.hi("TSProperty", { link = "TSKeyword" })

			api.hi("FloatBorder", { fg = "#4c4d54" })
			api.hi("VertSplit", { bg = "NONE", fg = "#0f1117" })

			-- Override diagnostic colors
			api.hi("DiagnosticFloatingHint", { link = "Normal" })

			-- Better completion menu coloring
			api.hi("CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true, fg = "#808080" })
			api.hi("CmpItemAbbrMatch", { bg = "NONE", fg = "#B78E6F" })
			api.hi("CmpItemKindFunction", { bg = "NONE", fg = "#C586C0" })
			api.hi("CmpItemKind", { link = "Normal" })
			api.hi("CmpItemKindKeyword", { link = "CmpItemKind" })
			api.hi("CmpItemKindVariable", { link = "CmpItemKind" })
			api.hi("CmpItemAbbrMatchFuzzy", { link = "CmpItemAbbrMatch" })
			api.hi("CmpItemKindInterface", { link = "CmpItemKindAbbrMatch" })
			api.hi("CmpItemKindText", { link = "CmpItemKindVariable" })
			api.hi("CmpItemKindMethod", { link = "CmpItemKindFunction" })
			api.hi("CmpItemKindProperty", { link = "CmpItemKindKeyword" })
			api.hi("CmpItemKindField", { link = "Keyword" })
			api.hi("CmpItemKindUnit", { link = "CmpItemKindKeyword" })

			--- Override diff colors
			api.hi("DiffAdd", { bg = "#4c5340", fg = "NONE" })
			api.hi("DiffChange", { bg = "#32382e", fg = "NONE" })
			api.hi("DiffDelete", { bg = "#53343b", fg = "NONE" })
			api.hi("DiffText", { bg = "#4c5340", fg = "NONE" })
		else
			-- if background == "light"
			api.hi("DiffAdd", { bg = "#d4dbd1", fg = "NONE" })
			api.hi("DiffChange", { bg = "#cfd7ca", fg = "NONE" })
			api.hi("DiffDelete", { bg = "#edbabd", fg = "NONE" })
			api.hi("DiffText", { bg = "#c1cdb8", fg = "NONE" })

			api.hi("VertSplit", { bg = "NONE", fg = "#cad0de" })
		end
	end,
})
