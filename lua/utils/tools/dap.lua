local utils = require("utils.helpers")
local icons = require("utils.icons")

local M = {}

M.debuggers = {
	["js-debug-adapter"] = require("utils.tools.settings.js-debug-adapter"),
	["delve"] = require("utils.tools.settings.delve"),
}

function M.setup_dap_ui()
	local dap, dapui = require("dap"), require("dapui")

	dapui.setup()

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open({})
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close({})
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close({})
	end

	for name, icon in pairs(icons.dap) do
		local sign = "Dap" .. name
		local linehl = sign == "DapStopped" and "Visual" or ""
		local numhl = sign == "DapStopped" and "CursorLineNr" or ""
		vim.fn.sign_define(sign, { text = icon, texthl = sign, linehl = linehl, numhl = numhl })
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
