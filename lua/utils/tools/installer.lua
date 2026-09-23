local M = {}

local utils = require("utils.helpers")
local tools = require("utils.tools.spec")

---Setup mason so it can manage external tooling
function M.setup_mason()
	require("mason").setup({ PATH = "append" })

	-- Adds `:LspInstall` and `:LspUninstall`, which take lspconfig server names such as `lua_ls`, and shows those
	-- names next to the packages in `:Mason`. `automatic_enable` is off because `lsp.lua` enables servers itself,
	-- including ones that are not installed by mason.
	require("mason-lspconfig").setup({ automatic_enable = false })

	-- Auto install tools
	require("mason-tool-installer").setup({
		ensure_installed = utils.concat_tables(tools.default_tools, tools.default_servers),
	})
end

return M
