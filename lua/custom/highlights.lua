local M = {}

local api = require("utils.api")

---Runs all non-colorscheme highlight overrides
function M.plugins()
	M.dashboard()
	M.nvim_tree()
	M.dap_ui()
	M.octo()
	M.dadbod()
	M.circleci()
	M.blink()
	M.leap()
	M.render_markdown()
end

---Overrides highlights for 'glepnir/dashboard-nvim'
function M.dashboard()
	api.hi("DashboardIcon", { fg = "#85A4F2", bg = "none" })
	api.hi("DashboardShortCut", { fg = "#85A4F2", bg = "none" })
	api.hi("DashboardFooter", { fg = "#7C7F96", bg = "none" })
end

---Overrides highlights for 'kyazdani42/nvim-tree.lua'
function M.nvim_tree()
	api.hi("NvimTreeSpecialFile", { bold = true })
	api.hi("NvimTreeRootFolder", { link = "Constant" })
end

---Overrides highlights for 'kristijanhusak/vim-dadbod-ui'
function M.dadbod()
	api.hi("NotificationInfo", { link = "Normal" })
	api.hi("NotificationWarning", { link = "Normal" })
	api.hi("NotificationError", { link = "Normal" })
end

---Overrides highlights for 'rcarriga/nvim-dap-ui'
function M.dap_ui()
	local winbar = api.get_highlight("WinBar")
	local diagnostic_info = api.get_highlight("DiagnosticInfo")
	local diagnostic_error = api.get_highlight("DiagnosticError")
	local ts_function = api.get_highlight("TSFunction")

	api.hi("DapUIScope", { link = "Statement" })
	api.hi("DapUIType", { link = "Type" })
	api.hi("DapUIDecoration", { link = "Type" })
	api.hi("DapUIThread", { link = "TSFunction" })
	api.hi("DapUIStoppedThread", { link = "String" })
	api.hi("DapUIWatchesEmpty", { link = "DiagnosticWarn" })
	api.hi("DapUIWatchesValue", { link = "DiagnosticInfo" })
	api.hi("DapUIWatchesError", { link = "DiagnosticError" })
	api.hi("DapUIBreakpointsPath", { link = "DapUIScope" })
	api.hi("DapUIBreakpointsInfo", { link = "TSFunction" })
	api.hi("DapUILineNumber", { link = "Statement" })
	api.hi("DapUIBreakpointsCurrentLine", { link = "TSFunction" })
	api.hi("DapUISource", { link = "Type" })
	api.hi("DapUIModifiedValue", { link = "Statement" })
	api.hi("DapStoppedLine", { link = "Visual" })

	-- Control bar buttons
	api.hi("DapUIPlayPause", { bg = winbar.bg, fg = ts_function.fg })
	api.hi("DapUIStepInto", { bg = winbar.bg, fg = diagnostic_info.fg })
	api.hi("DapUIStepOver", { bg = winbar.bg, fg = diagnostic_info.fg })
	api.hi("DapUIStepOut", { bg = winbar.bg, fg = diagnostic_info.fg })
	api.hi("DapUIStepBack", { bg = winbar.bg, fg = diagnostic_info.fg })
	api.hi("DapUIRestart", { bg = winbar.bg, fg = ts_function.fg })
	api.hi("DapUIStop", { bg = winbar.bg, fg = diagnostic_error.fg })
end

---Overrides highlights for 'pwntester/octo.nvim'
function M.octo()
	local hi = api.get_highlight("TabLine")
	api.hi("OctoEditable", { bg = hi.bg })
end

---Overrides highlights for 'ismailshak/circleci.nvim'
function M.circleci()
	local constant = api.get_highlight("Constant")
	api.hi("CircleCIPanelWinBar", { fg = constant.fg, bold = true })
	api.hi("CircleCIPanelWinBarNC", { fg = constant.fg })
end

---Overrides highlights for 'saghen/blink.cmp'
function M.blink()
	api.hi("BlinkCmpDocBorder", { link = "FloatBorder" })
end

---Overrides highlights for 'ggandor/leap.vim'
function M.leap()
	api.hi("LeapLabel", {}) -- Without this labels don't highlight
end

---Overrides highlights for 'MeanderingProgrammer/render-markdown.nvim'
function M.render_markdown()
	api.hi("RenderMarkdownH1Bg", { link = "CursorLineNr" })
	api.hi("RenderMarkdownH2Bg", { link = "RenderMarkdownH1Bg" })
	api.hi("RenderMarkdownH3Bg", { link = "RenderMarkdownH1Bg" })
	api.hi("RenderMarkdownH4Bg", { link = "RenderMarkdownH1Bg" })
	api.hi("RenderMarkdownH5Bg", { link = "RenderMarkdownH1Bg" })
	api.hi("RenderMarkdownH6Bg", { link = "RenderMarkdownH1Bg" })
	api.hi("RenderMarkdownDash", { link = "WinSeparator" })
	api.hi("RenderMarkdownQuote", { link = "Comment" })
	api.hi("RenderMarkdownTableHead", { link = "Normal" })
	api.hi("RenderMarkdownTableRow", { link = "Normal" })
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

	----------------------
	-- Plugin overrides --
	----------------------

	M.iceberg_blink()
	M.icberg_telescope(is_dark)

	--------------------------------
	-- Global highlight overrides --
	--------------------------------

	-- v0.10.0 changed this to link to Normal, I'm reverting it for iceberg
	api.hi("WinSeparator", { link = "VertSplit" })

	api.hi("Type", { link = "Constant" })

	-- Override floating window colors
	api.hi("NormalFloat", { link = "Normal" })

	-- JSX highlighting
	api.hi("htmlTagName", { link = "Statement" })

	-- OCaml highlighting
	api.hi("@constructor.ocaml", { link = "TSType" })

	-- Completion menu
	api.hi("Pmenu", { bg = "NONE" })
	api.hi("PmenuSel", { link = "Visual" })
	api.hi("PmenuExtra", { link = "Comment" })

	-- Markdown quote blocks
	api.hi("@markup.quote.markdown", { link = "Comment" })
	api.hi("@punctuation.special.markdown", { link = "Normal" })

	---------------------------------
	-- Dynamic highlight overrides --
	---------------------------------

	if is_dark then
		-- Override syntax colors
		api.hi("NonText", { fg = "#3f4660" }) -- Virtual text
		api.hi("Keyword", { ctermfg = 110, fg = "#84a0c6" })
		api.hi("TSFunction", { ctermfg = 252, fg = "#b4be82" })
		api.hi("Identifier", { link = "TSVariable" })
		api.hi("TSConstructor", { link = "TSFunction" })
		api.hi("TSProperty", { link = "TSKeyword" })

		api.hi("FloatBorder", { fg = "#4c4d54" })
		api.hi("VertSplit", { bg = "NONE", fg = "#0f1117" })

		-- Override diagnostic colors
		api.hi("DiagnosticFloatingHint", { link = "Normal" })

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

		-- OCaml highlighting
		api.hi("@constructor.ocaml", { link = "TSFunction" }) -- default dark highlighting
		api.hi("@property.ocaml", { link = "Statement" }) -- default dark highlighting
	end
end

-- Iceberg specific integration with `saghen/blink.cmp`
function M.iceberg_blink()
	local normal_hg = api.get_highlight("Normal")

	api.hi("BlinkCmpLabelMatch", { link = "PmenuMatch" })
	api.hi("BlinkCmpLabelDeprecated", { link = "DiagnosticDeprecated" })
	api.hi("BlinkCmpMenu", { link = "NormalFloat" })
	api.hi("BlinkCmpMenuBorder", { link = "FloatBorder" })

	api.hi("BlinkCmpKindEnum", { link = "Title" })
	api.hi("BlinkCmpLabelDescription", { link = "Comment" })
	api.hi("BlinkCmpKindClass", { link = "Function" })
	api.hi("BlinkCmpKindStruct", { link = "BlinkCmpKindClass" })
	api.hi("BlinkCmpKindInterface", { link = "BlinkCmpKindClass" })
	api.hi("BlinkCmpKindKeyword", { link = "Keyword" })
	api.hi("BlinkCmpKindField", { link = "BlinkCmpKindKeyword" })
	api.hi("BlinkCmpKindUnit", { link = "BlinkCmpKindKeyword" })
	api.hi("BlinkCmpKindConstant", { link = "BlinkCmpKindKeyword" })
	api.hi("BlinkCmpKindVariable", { link = "BlinkCmpKindKeyword" })
	api.hi("BlinkCmpKindFunction", { link = "Constant" })
	api.hi("BlinkCmpKindConstructor", { link = "BlinkCmpKindFunction" })
	api.hi("BlinkCmpKindMethod", { link = "BlinkCmpKindFunction" })
	api.hi("BlinkCmpKindProperty", { link = "BlinkCmpKindKeyword" })
	api.hi("BlinkCmpKindVariable", { bg = "NONE", fg = normal_hg.fg })
	api.hi("BlinkCmpKindText", { link = "BlinkCmpKindVariable" })
	api.hi("BlinkCmpKindSnippet", { link = "BlinkCmpKindVariable" })
	api.hi("BlinkCmpKindColor", { link = "BlinkCmpKindVariable" })
end

---Overrides highlights for 'nvim-telescope/telescope.nvim' just for iceberg
function M.icberg_telescope(is_dark)
	local normal_hg = api.get_highlight("Normal")
	local pmenu_hg = api.get_highlight("Pmenu")

	if is_dark then
		local telescope_bg = "#0f1117"
		local telescope_prompt_bg = "#1e2132"

		api.hi("TelescopePromptTitle", { fg = normal_hg.fg })
		api.hi("TelescopePromptNormal", { bg = telescope_prompt_bg, fg = pmenu_hg.fg })
		api.hi("TelescopePromptBorder", { bg = telescope_prompt_bg, fg = telescope_prompt_bg })
		api.hi("TelescopePromptPrefix", { bg = telescope_prompt_bg, fg = pmenu_hg.fg })
		api.hi("TelescopePromptCounter", { fg = pmenu_hg.fg })

		api.hi("TelescopeResultsTitle", {})
		api.hi("TelescopeResultsNormal", { bg = telescope_bg })
		api.hi("TelescopeResultsBorder", { fg = telescope_bg, bg = telescope_bg })

		api.hi("TelescopePreviewTitle", {})
		api.hi("TelescopePreviewNormal", { bg = telescope_bg })
		api.hi("TelescopePreviewBorder", { fg = telescope_bg, bg = telescope_bg })
	else
		api.hi("CurSearch", { bg = "#d07f47", fg = "#6c3c1b" })

		local telescope_bg = "#e0e2e6"
		local telescope_prompt_bg = "#d3d8e4"

		api.hi("TelescopePromptTitle", { fg = normal_hg.fg })
		api.hi("TelescopePromptNormal", { bg = telescope_prompt_bg, fg = pmenu_hg.fg })
		api.hi("TelescopePromptBorder", { bg = telescope_prompt_bg, fg = telescope_prompt_bg })
		api.hi("TelescopePromptPrefix", { bg = telescope_prompt_bg, fg = pmenu_hg.fg })
		api.hi("TelescopePromptCounter", { fg = pmenu_hg.fg })

		api.hi("TelescopeResultsTitle", {})
		api.hi("TelescopeResultsNormal", { bg = telescope_bg })
		api.hi("TelescopeResultsBorder", { fg = telescope_bg, bg = telescope_bg })

		api.hi("TelescopePreviewTitle", {})
		api.hi("TelescopePreviewNormal", { bg = telescope_bg })
		api.hi("TelescopePreviewBorder", { fg = telescope_bg, bg = telescope_bg })
	end
end

return M
