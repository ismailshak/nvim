local M = {}

local utils = require("utils.helpers")

M.languages = {
	"javascript",
	"typescript",
	"javascriptreact",
	"typescriptreact",
}

---An adapter that starts js-debug-adapter on a free port. nvim-dap picks the port and replaces `${port}` in both places
---@param extra? table Fields merged into the adapter
---@return table
local function js_debug_adapter(extra)
	return vim.tbl_extend("force", {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = vim.fn.exepath("js-debug-adapter"),
			args = { "${port}" },
		},
	}, extra or {})
end

function M.adapters()
	local dap = require("dap")

	dap.adapters["pwa-node"] = js_debug_adapter()
	dap.adapters["pwa-chrome"] = js_debug_adapter()

	-- `.vscode/launch.json` files use the `chrome` type. js-debug-adapter only knows `pwa-chrome`.
	dap.adapters.chrome = js_debug_adapter({
		enrich_config = function(config, on_config)
			local updated_config = utils.deep_clone(config)
			if config.type == "chrome" then
				updated_config.type = "pwa-chrome"
			end

			on_config(updated_config)
		end,
	})
end

function M.configurations()
	local dap = require("dap")

	for _, lang in ipairs(M.languages) do
		dap.configurations[lang] = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch current file (nodejs)",
				program = "${file}",
				cwd = "${workspaceFolder}",
				sourceMaps = true,
			},
			{
				type = "pwa-node",
				request = "attach",
				name = "Attach to inspector process (nodejs)",
				protocol = "inspector",
				port = 9229,
				cwd = "${workspaceFolder}",
				sourceMaps = true,
			},
			{
				type = "chrome",
				request = "launch",
				name = "Launch Chrome (web)",
				url = function()
					local input = vim.fn.input({
						prompt = "URL:",
						default = "http://localhost:3000",
						cancelreturn = "",
					})

					if input == "" then
						return
					end

					return input
				end,
				webRoot = "${workspaceFolder}",
				sourceMaps = true,
				port = 9222,
				-- Since I don't use Chrome, I don't care if it doesn't sandbox this into a temp instance
				-- and it's convenient when it shares auth cookies etc (or at least I think it does)
				userDataDir = true,
			},
			-- Dummy separator to make it easy to find injected configurations
			{
				name = "----- .vscode/launch.json -----",
				type = "launch",
				request = "launch",
			},
		}
	end
end

function M.setup()
	M.adapters()
	M.configurations()
end

return M
