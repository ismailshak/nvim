local icons = require("utils.icons")

local M = {}

-- Maximum virtual text characters before cutting off
local VIRTUAL_TEXT_MAX_LENGTH = 40

M.debuggers = {
	["delve"] = require("utils.tools.settings.delve"),
	["js-debug-adapter"] = require("utils.tools.settings.js-debug-adapter"),
	["codelldb"] = require("utils.tools.settings.codelldb"),
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

---Formats a variable's value for virtual text. Newlines become spaces, and values longer than
---`VIRTUAL_TEXT_MAX_LENGTH` are cut short.
---@param variable dap.Variable
---@return string
local function format_virtual_text(variable)
	local value = variable.value:gsub("%s*\n%s*", " ")
	if vim.fn.strchars(value) > VIRTUAL_TEXT_MAX_LENGTH then
		value = vim.fn.strcharpart(value, 0, VIRTUAL_TEXT_MAX_LENGTH - 1) .. "…"
	end
	return " " .. value
end

function M.setup_dap_view()
	require("dap-view").setup({
		winbar = {
			controls = { enabled = true },
		},
		windows = { position = "below" },
		hover = { border = "rounded" },
		help = { border = "rounded" },
		virtual_text = {
			enabled = true,
			format = format_virtual_text,
		},
		-- Opens the panel when a session starts and closes it when the last session ends
		auto_toggle = true,
	})

	M.configure_icons()
end

---Shows a fidget spinner from the moment a debug session starts until the debug adapter responds to the launch or
---attach request. Also notifies when the program exits with a non-zero code.
---nvim-dap already notifies when an adapter fails to start or rejects the launch.
function M.report_progress()
	local dap = require("dap")
	local progress = require("fidget.progress")

	-- Spinners by session id. Finished ones stay in the table so focusing the session again does not start a new one.
	local handles = {}

	local function finish(session_id, message)
		local handle = handles[session_id]
		if handle and not handle.done then
			handle.message = message
			handle:finish()
		end
	end

	dap.listeners.on_session["fidget"] = function(_, new)
		-- Only top-level sessions get a spinner. Child sessions, such as the ones js-debug-adapter starts for each
		-- process, are not in `dap.sessions()`, so the check below would end their spinner straight away.
		if new and not new.parent and not handles[new.id] then
			handles[new.id] = progress.handle.create({
				title = new.config.name,
				message = "Launching",
				lsp_client = { name = "nvim-dap" },
			})
		end

		-- nvim-dap removes a session from `dap.sessions()` before it calls this listener for the close
		for id in pairs(handles) do
			if not dap.sessions()[id] then
				finish(id, "Ended")
			end
		end
	end

	vim.api.nvim_create_autocmd("User", {
		pattern = "DapProgressUpdate",
		callback = function()
			-- dap.status() removes the message from nvim-dap's queue. It is read even when no spinner is shown, so a
			-- later spinner does not start with old messages.
			local message = dap.status()
			local session = dap.session()
			local handle = session and handles[session.id]
			if handle and not handle.done and message ~= "" then
				handle.message = message
			end
		end,
	})

	for _, request in ipairs({ "launch", "attach" }) do
		dap.listeners.before[request]["fidget"] = function(session, err)
			finish(session.id, err and "Failed" or "Running")
		end
	end

	dap.listeners.after.event_exited["fidget"] = function(session, body)
		if body.exitCode ~= 0 then
			vim.notify(string.format("%s exited with code %d", session.config.name, body.exitCode), vim.log.levels.WARN)
		end
	end
end

function M.setup_dap()
	for _, config in pairs(M.debuggers) do
		config.setup()
	end
end

return M
