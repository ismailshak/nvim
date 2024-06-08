local M = {}

local utils = require("utils.helpers")
local tools = require("utils.tools.spec")

---Setup mason so it can manage external tooling
function M.setup_mason()
	require("mason").setup({ PATH = "append" })

	-- Auto install tools
	require("mason-tool-installer").setup({
		ensure_installed = utils.concat_tables(tools.default_tools, tools.default_servers),
	})
end

return M
