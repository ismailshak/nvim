local M = {}

local utils = require("utils.helpers")

M.languages = {
	"javascript",
	"typescript",
	"javascriptreact",
	"typescriptreact",
}

function M.adapters()
	local dap = require("dap")

	dap.adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "8123",
		executable = {
			command = vim.fn.exepath("js-debug-adapter"),
			args = { "8123" },
		},
	}

	dap.adapters["pwa-chrome"] = {
		type = "server",
		host = "localhost",
		port = "8123",
		executable = {
			command = vim.fn.exepath("js-debug-adapter"),
			args = { "8123" },
		},
	}

	-- This is a hack to get the chrome type in .vscode/launch.json to work with the pwa-chrome type
	-- that the js-debug-adapter supports
	dap.adapters.chrome = {
		type = "server",
		host = "localhost",
		port = "8123",
		executable = {
			command = vim.fn.exepath("js-debug-adapter"),
			args = { "8123" },
		},
		enrich_config = function(config, on_config)
			local updated_config = utils.deep_clone(config)
			if config.type == "chrome" then
				updated_config.type = "pwa-chrome"
			end

			on_config(updated_config)
		end,
	}
end

--- Maps the .vscode/launch.json config types to the languages they support
---@return table
function M.get_launch_ext()
	return {
		["chrome"] = M.languages,
		["pwa-chrome"] = M.languages,
		["node"] = M.languages,
		["pwa-node"] = M.languages,
	}
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

	return M.get_launch_ext()
end

function M.setup()
	M.adapters()
	return M.configurations()
end

return M
