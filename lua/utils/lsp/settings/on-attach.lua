local mappings = require("custom.mappings")

local M = {}

M.gen_desc = function(desc)
	return desc .. " (LSP)"
end

function M.on_attach(client, bufnr)
	mappings.lsp(bufnr)

	-- Disable LSP formatting
	client.server_capabilities.document_formatting = false
end

return M
