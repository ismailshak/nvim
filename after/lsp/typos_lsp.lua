---@type vim.lsp.Config
return {
	init_options = {
		config = vim.fn.stdpath("config") .. "/spell/typos.toml",
		diagnosticSeverity = "Warning", -- "Error" | "Warning" | "Info" | "Hint"
	},
}
