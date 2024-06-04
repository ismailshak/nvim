local utils = require("utils.helpers")
local icons = require("utils.icons")

local M = {}

M.debuggers = {
	["js-debug-adapter"] = require("utils.tools.settings.js-debug-adapter"),
	["delve"] = require("utils.tools.settings.delve"),
}

function M.configure_icons()
	for name, icon in pairs(icons.dap) do
		local sign = "Dap" .. name
		local texthl = sign == "DapStopped" and "CursorLineNr" or "DiagnosticSignError"
		local linehl = sign == "DapStopped" and "Visual" or ""
		local numhl = sign == "DapStopped" and "CursorLineNr" or ""
		vim.fn.sign_define(sign, { text = icon, texthl = texthl, linehl = linehl, numhl = numhl })
	end
end

function M.setup_dap_ui()
	local dap, dapui = require("dap"), require("dapui")

	dapui.setup({
		layouts = {
			{
				elements = {
					{ id = "scopes", size = 0.4 },
					{ id = "watches", size = 0.3 },
					{ id = "stacks", size = 0.2 },
					{ id = "breakpoints", size = 0.1 },
				},
				position = "right",
				size = 40,
			},
			{
				elements = {
					{ id = "console", size = 0.25 },
					{ id = "repl", size = 0.75 },
				},
				position = "bottom",
				size = 10,
			},
		},
	})

	M.configure_icons()

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open({})
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close({})
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close({})
	end

	require("nvim-dap-virtual-text").setup({
		clear_on_continue = true,
	})
end

function M.setup_dap()
	local types_to_filetypes = {}

	for _, config in pairs(M.debuggers) do
		local launch_ext = config.setup()

		if launch_ext then
			types_to_filetypes = utils.merge_tables(types_to_filetypes, launch_ext)
		end
	end

	require("dap.ext.vscode").load_launchjs(nil, types_to_filetypes)
end

return M
