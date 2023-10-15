local api = require("utils.api")

local M = {}

M.gen_desc = function(desc)
	return desc .. " (LSP)"
end

function M.on_attach(client, bufnr)
	local opts = { buffer = bufnr }
	api.nmap("<leader>rn", vim.lsp.buf.rename, M.gen_desc("[R]e[n]ame"), opts)
	api.nmap("<leader>ca", vim.lsp.buf.code_action, M.gen_desc("[C]ode [A]ction"), opts)
	api.vmap("<leader>ca", vim.lsp.buf.code_action, M.gen_desc("Selected range [C]ode [A]ction"), opts)

	api.nmap("gd", vim.lsp.buf.definition, M.gen_desc("[G]oto [D]efinition"), opts)
	api.nmap("gr", require("telescope.builtin").lsp_references, M.gen_desc("[G]oto [R]eferences"), opts)
	api.nmap("gI", vim.lsp.buf.implementation, M.gen_desc("[G]oto [I]mplementation"), opts)
	api.nmap("<leader>D", vim.lsp.buf.type_definition, M.gen_desc("Type [D]efinition"), opts)
	api.nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, M.gen_desc("[D]ocument [S]ymbols"), opts)
	api.nmap(
		"<leader>ws",
		require("telescope.builtin").lsp_dynamic_workspace_symbols,
		M.gen_desc("[W]orkspace [S]ymbols"),
		opts
	)

	-- See `:help K` for why this keymap
	api.nmap("K", vim.lsp.buf.hover, M.gen_desc("Hover Documentation"), opts)
	api.nmap("<C-i>", vim.lsp.buf.signature_help, M.gen_desc("Signature Documentation"), opts)

	-- Lesser used LSP functionality
	api.nmap("gD", vim.lsp.buf.declaration, M.gen_desc("[G]oto [D]eclaration"), opts)
	api.nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, M.gen_desc("[W]orkspace [A]dd Folder"), opts)
	api.nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, M.gen_desc("[W]orkspace [R]emove Folder"), opts)
	api.nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, M.gen_desc("[W]orkspace [L]ist Folders"), opts)

	-- Disable LSP formatting
	client.server_capabilities.document_formatting = false
end

return M
