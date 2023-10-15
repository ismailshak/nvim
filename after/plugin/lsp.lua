local utils = require("utils.helpers")
if not utils.exists("mason") then
	return
end

local settings = require("custom.settings")

-----------------------
-- LSP CONFIGURATION --
-----------------------

local servers = {
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

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic errors" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic errors" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Open diagnostic error window" })
-- vim.keymap.set("n", "<leader>sl", vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = require("lsp_settings.on-attach").on_attach

-- Configure diagnostics
local diagnosticsConfig = require("lsp_settings.diagnostics").config
vim.diagnostic.config(diagnosticsConfig)

-- Fix floating window styles
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "rounded",
})

-- Setup mason so it can manage external tooling
require("mason").setup() -- Ensure the servers above are installed
require("mason-lspconfig").setup({
	ensure_installed = servers,
})

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup all servers with default config
for _, lsp in ipairs(servers) do
	require("lspconfig")[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

-- JSON overrides
require("lspconfig").jsonls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = require("lsp_settings.jsonls").settings,
	setup = require("lsp_settings.jsonls").setup,
})

-- Elixir overrides
require("lspconfig").elixirls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = require("lsp_settings.elixirls").settings,
})

--------------------------
-- FORMATTING & LINTING --
--------------------------

local null_ls = require("null-ls")

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
--[[ local completion = null_ls.builtins.completion ]]

local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

local function should_disable_formatting(cwd)
	local dirs = settings.get().disable_format
	if dirs == "" then
		return false
	end

	for _, dir in ipairs(utils.split(dirs, ",")) do
		if string.find(cwd, dir) then
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
