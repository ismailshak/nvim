local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion

null_ls.setup({
	debug = false,
	sources = {
		formatting.prettier,
		formatting.stylua,
		formatting.gofmt,
		-- formatting.goimports, -- TODO: set this up, will replace gofmt and will handle auto imports
		diagnostics.eslint,
		diagnostics.codespell,
		code_actions.gitsigns,
		code_actions.eslint,
	},
})
