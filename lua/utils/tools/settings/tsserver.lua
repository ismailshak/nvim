local M = {}

local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "Organize import lines",
	}

	vim.lsp.buf.execute_command(params)
end

M.commands = {
	OrganizeImports = {
		organize_imports,
		description = "Organize Imports",
	},
}

return M
