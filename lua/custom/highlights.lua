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
	M.copilot_chat()
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

function M.copilot_chat()
	api.hi("CopilotChatHeader", { link = "Function" })
	api.hi("CopilotChatHelp", { link = "Comment" })
	api.hi("CopilotChatSeparator", { link = "Comment" })
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

	-- v0.10.0 changed this to link to Normal, I'm reverting it for iceberg
	api.hi("WinSeparator", { link = "VertSplit" })

	api.hi("Type", { link = "Constant" })

	-- Override floating window colors
	api.hi("NormalFloat", { link = "Normal" })
	api.hi("FloatBorder", { link = "Normal" })

	-- JSX highlighting
	api.hi("htmlTagName", { link = "Statement" })

	-- OCaml highlighting
	api.hi("@constructor.ocaml", { link = "TSType" })

	---------------------------------
	-- Dynamic highlight overrides --
	---------------------------------

	M.icberg_telescope(is_dark)

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

		-- OCaml highlighting
		api.hi("@constructor.ocaml", { link = "TSFunction" }) -- default dark highlighting
		api.hi("@property.ocaml", { link = "Statement" }) -- default dark highlighting
	end
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
