local M = {}

-- TODO: backfill this to template
M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		-- disable virtual text
		virtual_text = {
			severity = "error",
		},
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
			false
		)
	end
end

local function lsp_keymaps(bufnr)
	local utils = require("utils.keybindings")
	utils.buf_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
	utils.buf_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
	utils.buf_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
	utils.buf_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
	utils.buf_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
	utils.buf_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
	utils.buf_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
	utils.buf_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>')
	utils.buf_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
	utils.buf_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>')
	utils.buf_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>")
	utils.buf_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
	utils.buf_keymap(bufnr, "n", "<leader>lf", ":Format <CR>")
	vim.api.nvim_buf_create_user_command(bufnr, "Format", vim.lsp.buf.formatting, {})

	local telescope_present, _ = pcall(require, "telescope.builtin")
	if telescope_present then
		utils.buf_keymap(bufnr, "n", "<leader>fs", "<cmd>lua require('telescope.builtin').lsp_document_symbols() <CR>")
	end
end

local disable_client_formatting = function(client, server)
	if client.name == server then
		client.resolved_capabilities.document_formatting = false
	end
end

M.on_attach = function(client, bufnr)
	disable_client_formatting(client, "tsserver")
  disable_client_formatting(client, "gopls")
	disable_client_formatting(client, "sumneko_lua")
	lsp_keymaps(bufnr) -- set up keymaps
	lsp_highlight_document(client) -- enable highlighting tokens
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	print("NO")
	return
end

-- hook up cmp capabilities
M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
