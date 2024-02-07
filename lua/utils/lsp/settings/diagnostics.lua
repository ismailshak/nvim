local icons = require("utils.icons")

local M = {}

local signs = {
	{ name = "DiagnosticSignError", text = icons.diagnostics.error },
	{ name = "DiagnosticSignWarn", text = icons.diagnostics.warn },
	{ name = "DiagnosticSignInfo", text = icons.diagnostics.info },
	{ name = "DiagnosticSignHint", text = icons.diagnostics.hint },
}

for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

M.config = {
	-- disable virtual text
	virtual_text = {
		severity = "error",
	},
	-- show signs
	signs = {
		active = signs,
	},
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
}

return M
