local M = {}

local mappings = require("custom.mappings")
local settings = require("custom.settings")
local utils = require("utils.helpers")
local tools = require("utils.tools.spec")

function M.setup_lsp()
	M.setup_neodev()
	M.setup_diagnostics()
	M.configure_floating_window()
	M.configure_cmp()
	M.configure_servers()
	M.setup_null_ls()
end

M.servers = utils.concat_tables(tools.auto_install_lsp, tools.system_lsp)

M.capabilities = vim.lsp.protocol.make_client_capabilities()

function M.setup_neodev()
	require("neodev").setup({
		-- https://github.com/folke/neodev.nvim/issues/158#issuecomment-1682565350
		pathStrict = true,
	})
end

---nvim-cmp supports additional completion capabilities
function M.configure_cmp()
	M.capabilities = require("cmp_nvim_lsp").default_capabilities(M.capabilities)
end

function M.setup_diagnostics()
	-- Configure diagnostics
	local diagnosticsConfig = require("utils.tools.settings.diagnostics").config
	vim.diagnostic.config(diagnosticsConfig)
end

function M.configure_floating_window()
	-- Fix floating window styles
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
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
		commands = require("utils.tools.settings.tsserver").commands,
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
end

function M.setup_null_ls()
	local null_ls = require("null-ls")

	-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
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
			formatting.clang_format,
			formatting.goimports, -- fixes imports and formats the same way `gofmt` does
			formatting.ocamlformat,
			formatting.prettier,
			formatting.rustfmt,
			formatting.shfmt,
			formatting.stylua,
			diagnostics.codespell,
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
end

return M
