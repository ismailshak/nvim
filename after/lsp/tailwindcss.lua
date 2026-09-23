local vscode = require("utils.vscode")

---@type vim.lsp.Config
return {
	-- `vim.lsp.enable` skips a server that is not on PATH only when `cmd` is a list. lspconfig's `cmd` is a function.
	-- With it, every project with a `.git` directory warns that the server failed to start.
	cmd = { "tailwindcss-language-server", "--stdio" },
	settings = {
		tailwindCSS = {
			experimental = {
				configFile = vscode.find_setting("tailwindCSS.experimental.configFile"),
			},
		},
	},
}
