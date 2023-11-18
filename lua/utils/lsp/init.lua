local M = {}

local utils = require("utils.helpers")
local settings = require("custom.settings")

M.servers = {
	"tsserver",
	"eslint",
	"lua_ls",
	"gopls",
	"jsonls",
	"bashls",
	"marksman",
	"dockerls",
	"html",
	"cssls",
	"yamlls",
	"elixirls",
	"rust_analyzer",
}

M.setup_neodev = function()
	require("neodev").setup({
		-- https://github.com/folke/neodev.nvim/issues/158#issuecomment-1682565350
		pathStrict = true,
	})
end

---Setup mason so it can manage external tooling
M.configure_mason = function()
	require("mason").setup() -- Ensure the servers above are installed
	require("mason-lspconfig").setup({
		ensure_installed = M.servers,
	})
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.on_attach = require("utils.lsp.settings.on-attach").on_attach

---nvim-cmp supports additional completion capabilities
M.configure_cmp = function()
	M.capabilities = require("cmp_nvim_lsp").default_capabilities(M.capabilities)
end

M.configure_diagnostics = function()
	-- Configure diagnostics
	local diagnosticsConfig = require("utils.lsp.settings.diagnostics").config
	vim.diagnostic.config(diagnosticsConfig)
end

M.configure_floating_window = function()
	-- Fix floating window styles
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

M.setup_lsps = function()
	-- Setup all servers with default config
	for _, lsp in ipairs(M.servers) do
		require("lspconfig")[lsp].setup({
			on_attach = M.on_attach,
			capabilities = M.capabilities,
		})
	end

	-- Override specific server configs
	require("lspconfig").tsserver.setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
		commands = require("utils.lsp.settings.tsserver").commands,
	})

	require("lspconfig").jsonls.setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
		settings = require("utils.lsp.settings.jsonls").settings,
		setup = require("utils.lsp.settings.jsonls").setup,
	})

	require("lspconfig").elixirls.setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
		settings = require("utils.lsp.settings.elixirls").settings,
	})
end

M.setup_null_ls = function()
	local null_ls = require("null-ls")

	-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics
	local code_actions = null_ls.builtins.code_actions

	local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

	local function should_disable_formatting(cwd)
		local dirs = settings.get().disable_format
		if dirs == "" then
			return false
		end

		for _, dir in ipairs(utils.split(dirs, ",")) do
			if utils.includes(cwd, dir) then
				return true
			end
		end
	end

	null_ls.setup({
		debug = false,
		sources = {
			formatting.prettier,
			formatting.stylua,
			formatting.goimports, -- fixes imports and formats the same way `gofmt` does
			formatting.mix,
			formatting.rustfmt,
			diagnostics.codespell,
			diagnostics.credo,
			code_actions.gitsigns,
		},
		-- Format on write
		on_attach = function(client, bufnr)
			local cwd = utils.cwd()
			local can_format = client.supports_method("textDocument/formatting")
			local should_format = can_format and not should_disable_formatting(cwd)
			if should_format then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ bufnr = bufnr })
					end,
				})
			end
		end,
	})

	-- Auto install null-ls binaries via mason
	require("mason-null-ls").setup({
		ensure_installed = nil,
		automatic_installation = { exclude = { "prettier", "eslint", "credo", "mix" } },
		automatic_setup = false,
	})
end

return M
