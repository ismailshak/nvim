local M = {}

local utils = require("utils.helpers")
local tools = require("utils.tools.spec")

---Appends mason's bin directory to PATH, the same as `require("mason").setup({ PATH = "append" })`. It runs at startup
---so that servers, formatters, linters and debuggers installed by mason are found before mason loads.
function M.add_to_path()
	vim.env.PATH = vim.env.PATH .. ":" .. vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
end

---Setup mason so it can manage external tooling
function M.setup_mason()
	-- `add_to_path` has already added mason's bin directory
	require("mason").setup({ PATH = "skip" })

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
