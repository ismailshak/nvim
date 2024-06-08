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
		"tsserver",
		"yamlls",
	},
	---Tools that will be automatically installed (linters/formatters/debuggers)
	default_tools = {
		"codespell",
		"js-debug-adapter",
		"markdownlint",
		"shellcheck",
		"shfmt",
		"stylua",
	},
	---Language servers that will be configured if found on system $PATH
	optional_servers = {
		"clangd",
		"gopls",
		"ocamllsp",
		"rust_analyzer",
		"svelte",
	},
	---Tools that will be hooked up if found on system $PATH (linters/formatters/debuggers)
	optional_tools = {
		"clang_format",
		"delve",
		"goimports",
		"ocamlformat",
		"prettier",
		"rustfmt",
	},
}
