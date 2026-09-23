---A floating terminal that keeps one shell for the whole session
local M = {}

---The terminal buffer, created on the first open, and the floating window showing it
local state = { buf = nil, win = nil }

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

---Closes the terminal window if it is open, otherwise opens it. The first open starts the shell.
function M.toggle()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_close(state.win, true)
		state.win = nil
		return
	end

	if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
		state.win = vim.api.nvim_open_win(state.buf, true, win_config())
	else
		state.buf = vim.api.nvim_create_buf(false, true)
		state.win = vim.api.nvim_open_win(state.buf, true, win_config())
		-- `:terminal` turns the empty buffer into a terminal running 'shell'. nvim deletes a buffer started this way
		-- when the shell exits, so the next open starts a new shell.
		vim.cmd.terminal()
		vim.bo[state.buf].bufhidden = "hide"
	end

	vim.wo[state.win].winhighlight = "NormalFloat:Normal"
	vim.cmd.startinsert()
end

vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("FloatingTerminal", { clear = true }),
	callback = function()
		if state.win and vim.api.nvim_win_is_valid(state.win) then
			vim.api.nvim_win_set_config(state.win, win_config())
		end
	end,
})

return M
