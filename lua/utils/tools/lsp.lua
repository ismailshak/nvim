local M = {}

local utils = require("utils.helpers")
local tools = require("utils.tools.spec")

M.servers = utils.concat_tables(tools.default_servers, tools.optional_servers)

---Sets the capabilities shared by every server and enables the servers. Per-server config is in `after/lsp/`.
function M.setup_lsp()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
	capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
	capabilities = vim.tbl_deep_extend("force", capabilities, require("lsp-file-operations").default_capabilities())

	vim.lsp.config("*", { capabilities = capabilities })

	-- lspconfig loads inside the BufReadPost or BufNewFile event of a buffer, before its filetype is detected. `enable`
	-- runs the FileType event for open buffers. Running it before detection makes `:setfiletype` skip the buffer.
	vim.schedule(function()
		vim.lsp.enable(M.servers)
	end)
end

return M
