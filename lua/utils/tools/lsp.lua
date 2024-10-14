local M = {}

local mappings = require("custom.mappings")
local utils = require("utils.helpers")
local tools = require("utils.tools.spec")

function M.setup_lsp()
	M.setup_diagnostics()
	M.configure_cmp()
	M.configure_servers()
end

M.servers = utils.concat_tables(tools.default_servers, tools.optional_servers)

M.capabilities = vim.lsp.protocol.make_client_capabilities()

---nvim-cmp supports additional completion capabilities
function M.configure_cmp()
	M.capabilities = require("cmp_nvim_lsp").default_capabilities(M.capabilities)
end

function M.setup_diagnostics()
	-- Configure diagnostics
	local diagnosticsConfig = require("utils.tools.settings.diagnostics").config
	vim.diagnostic.config(diagnosticsConfig)
end

-- Not used and float handling is done by noice.nvim
function M.configure_floating_window()
	-- Fix floating window styles
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
		max_width = utils.percentage_as_width(60),
		max_height = utils.percentage_as_width(40),
	})
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
		max_width = utils.percentage_as_width(50),
		max_height = utils.percentage_as_width(40),
	})
end

function M.on_attach(client, bufnr)
	mappings.lsp(bufnr)

	-- Disable LSP formatting
	client.server_capabilities.document_formatting = false
end

function M.configure_servers()
	-- Translates LSP names between both tools
	require("mason-lspconfig").setup()

	-- Configure folding
	M.capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	utils.merge_tables(M.capabilities, require("lsp-file-operations").default_capabilities())

	-- Setup all servers with default config
	for _, lsp in ipairs(M.servers) do
		require("lspconfig")[lsp].setup({
			on_attach = M.on_attach,
			capabilities = M.capabilities,
		})
	end

	-- Overriding specific server configs below

	require("lspconfig").eslint.setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
		filetypes = require("utils.tools.settings.eslint").filetypes,
		settings = require("utils.tools.settings.eslint").settings,
	})

	require("lspconfig").jsonls.setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
		settings = require("utils.tools.settings.jsonls").settings,
		setup = require("utils.tools.settings.jsonls").setup,
	})

	require("lspconfig").elixirls.setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
		settings = require("utils.tools.settings.elixirls").settings,
	})

	require("lspconfig").rust_analyzer.setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
		settings = require("utils.tools.settings.rust-analyzer").settings,
	})

	require("lspconfig").typos_lsp.setup({
		init_options = require("utils.tools.settings.typos_lsp").init_options,
	})
end

return M
