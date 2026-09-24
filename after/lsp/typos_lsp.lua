local markers = { "typos.toml", "_typos.toml", ".typos.toml", "pyproject.toml", "Cargo.toml" }

---@type vim.lsp.Config
return {
	init_options = {
		config = vim.fn.stdpath("config") .. "/spell/typos.toml",
		diagnosticSeverity = "Warning", -- "Error" | "Warning" | "Info" | "Hint"
	},
	-- Skip empty buffers
	root_dir = function(bufnr, on_dir)
		if vim.bo[bufnr].buftype ~= "" then
			return
		end
		on_dir(vim.fs.root(bufnr, markers) or vim.fn.getcwd())
	end,
}
