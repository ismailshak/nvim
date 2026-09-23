return {
	---Language servers that will be automatically installed
	default_servers = {
		"bashls",
		"cssls",
		"dockerls",
		"eslint",
		"html",
		"jsonls",
		"lua_ls",
		"marksman",
		"typos_lsp",
		"vtsls", -- TypeScript for projects on TypeScript 5 or 6, see `configure_typescript` in `lsp.lua`
		"yamlls",
	},
	---Tools that will be automatically installed (linters/formatters/debuggers)
	default_tools = {
		-- The `copilot` server, enabled by the `copilot` setting. This is the mason name because mason-lspconfig v1
		-- has no mapping for `copilot`.
		"copilot-language-server",
		"js-debug-adapter",
		"markdownlint",
		"shellcheck",
		"shfmt",
		"stylua",
	},
	---Language servers that will be configured if found on system $PATH
	optional_servers = {
		"clangd",
		"elixirls",
		"gopls",
		"graphql",
		"ocamllsp",
		-- "rust_analyzer", -- Handled by 'mrcjkb/rustaceanvim'
		"svelte",
		"tailwindcss",
		"tsc", -- TypeScript 7 or later, installed by the project's package.json
	},
	---Tools that will be hooked up if found on system $PATH (linters/formatters/debuggers)
	optional_tools = {
		"clang_format",
		"codelldb",
		"delve",
		"goimports",
		"ocamlformat",
		"prettier",
		"rustfmt",
		"sql-formatter",
	},
}
