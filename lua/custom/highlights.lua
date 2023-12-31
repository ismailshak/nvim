local M = {}

local api = require("utils.api")

---Runs all non-colorscheme highlight overrides
function M.plugins()
	M.dashboard()
	M.nvim_tree()
end

---Overrides highlights for 'glepnir/dashboard-nvim'
function M.dashboard()
	-- Override floating window colors
	api.hi("NormalFloat", { link = "Normal" })
	api.hi("FloatBorder", { link = "Normal" })
	-- nvim-dashboard highlights
	api.hi("DashboardIcon", { fg = "#85A4F2", bg = "none" })
	api.hi("DashboardShortCut", { fg = "#85A4F2", bg = "none" })
	api.hi("DashboardFooter", { fg = "#7C7F96", bg = "none" })
end

---Overrides highlights for 'kyazdani42/nvim-tree.lua'
function M.nvim_tree()
	api.hi("NvimTreeSpecialFile", { bold = true })
end

---Overrides highlights for the provided colorscheme
---@param colorscheme theme
---@param is_dark boolean
function M.colorscheme(colorscheme, is_dark)
	if colorscheme == "iceberg" then
		M.iceberg(is_dark)
	end

	if colorscheme == "substrata" then
		M.substrata()
	end
end

---Overrides highlights for the substrata color scheme
function M.substrata()
	-- Override floating window colors
	api.hi("NormalFloat", { link = "Normal" })
	api.hi("FloatBorder", { link = "Normal" })
end

---Overrides highlights for the iceberg color scheme
---@param is_dark boolean
function M.iceberg(is_dark)
	-- Disabling all semantic highlights for iceberg
	-- (I didn't like how rust highlighting looked compared to default)
	-- :h lsp-semantic-highlight
	for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
		api.hi(group, {})
	end

	--------------------------------
	-- Global highlight overrides --
	--------------------------------

	-- Override floating window colors
	api.hi("NormalFloat", { link = "Normal" })
	api.hi("FloatBorder", { link = "Normal" })

	-- JSX highlighting
	api.hi("htmlTagName", { link = "Statement" })

	---------------------------------
	-- Dynamic highlight overrides --
	---------------------------------

	if is_dark then
		-- Override syntax colors
		api.hi("NonText", { fg = "#3f4660" }) -- Virtual text
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
		api.hi("TSFunction", { ctermfg = 252, fg = "#668e3d" })
		api.hi("NonText", { fg = "#c6c8d1" }) -- Virtual text
		api.hi("DiffAdd", { bg = "#d4dbd1", fg = "NONE" })
		api.hi("DiffChange", { bg = "#cfd7ca", fg = "NONE" })
		api.hi("DiffDelete", { bg = "#edbabd", fg = "NONE" })
		api.hi("DiffText", { bg = "#c1cdb8", fg = "NONE" })

		api.hi("VertSplit", { bg = "NONE", fg = "#cad0de" })
	end
end

return M
