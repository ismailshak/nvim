---A floating terminal that keeps one shell for the whole session, with one window per tab on it
local M = {}

---The terminal buffer, created on the first open, and the floating window showing it in each tab page
local state = { buf = nil, wins = {} } ---@type { buf: integer?, wins: table<integer, integer> }

---Returns a centred window config that covers 80% of the editor. It is computed on every call so that it follows the
---editor's size.
---@return vim.api.keyset.win_config
local function win_config()
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	return {
		relative = "editor",
		width = width,
		height = height,
		-- The border adds one cell on each side
		col = math.floor((vim.o.columns - width - 2) / 2),
		row = math.floor((vim.o.lines - height - 2) / 2),
		border = "rounded",
	}
end

---Closes the terminal window in the current tab if it is open, otherwise opens one. Windows in other tabs are left
---alone. The first open starts the shell.
function M.toggle()
	local tab = vim.api.nvim_get_current_tabpage()
	local win = state.wins[tab]
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
		state.wins[tab] = nil
		return
	end

	-- nvim deletes a terminal buffer only when its shell exits with status 0. After any other status the buffer
	-- stays with no job in it, so it is deleted here and a new shell started.
	if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
		local running = vim.fn.jobwait({ vim.bo[state.buf].channel }, 0)[1] == -1
		if not running then
			vim.api.nvim_buf_delete(state.buf, { force = true })
			state.buf = nil
		end
	end

	if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
		win = vim.api.nvim_open_win(state.buf, true, win_config())
	else
		state.buf = vim.api.nvim_create_buf(false, true)
		win = vim.api.nvim_open_win(state.buf, true, win_config())
		-- `:terminal` turns the empty buffer into a terminal running 'shell'
		vim.cmd.terminal()
		vim.bo[state.buf].bufhidden = "hide"
	end
	state.wins[tab] = win

	-- The term ftplugin sets window options, which reach only the window the shell started in. Running it again
	-- applies them to this window.
	vim.cmd.runtime({ "after/ftplugin/term.lua", bang = true })
	vim.api.nvim_set_option_value("winhighlight", "NormalFloat:Normal", { scope = "local", win = win })
	vim.cmd.startinsert()
end

vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("FloatingTerminal", { clear = true }),
	callback = function()
		for tab, win in pairs(state.wins) do
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_set_config(win, win_config())
			else
				state.wins[tab] = nil
			end
		end
	end,
})

return M
