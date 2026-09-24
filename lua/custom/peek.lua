local utils = require("utils.helpers")

---Shows the definition of the symbol under the cursor in a floating window
local M = {}

---The open peek window, the buffer it shows, and the keys mapped in that buffer while it is open
local state = { win = nil, buf = nil, mapped = {} }

---Deletes the keys mapped for the peek window and forgets the window. Returns the window.
---@return integer?
local function forget()
	local win, buf = state.win, state.buf
	if buf and vim.api.nvim_buf_is_valid(buf) then
		for _, key in ipairs(state.mapped) do
			pcall(vim.keymap.del, "n", key, { buf = buf })
		end
	end
	state.win, state.buf, state.mapped = nil, nil, {}
	return win
end

---Closes the peek window if it is open
function M.close()
	local win = forget()
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
	end
end

---Returns the first location in the `textDocument/definition` results and the client that sent it
---@param results table<integer, { err?: lsp.ResponseError, result?: lsp.Location|lsp.Location[]|lsp.LocationLink[] }>
---@return (lsp.Location|lsp.LocationLink)?, vim.lsp.Client?
local function first_location(results)
	for client_id, response in pairs(results) do
		local result = response.result
		if result and not vim.tbl_isempty(result) then
			local location = vim.islist(result) and result[1] or result
			return location, vim.lsp.get_client_by_id(client_id)
		end
	end
end

---@param location lsp.Location|lsp.LocationLink
---@param client vim.lsp.Client
local function open(location, client)
	M.close()

	local origin = vim.api.nvim_get_current_win()
	local uri = location.targetUri or location.uri
	local buf = vim.uri_to_bufnr(uri)
	vim.fn.bufload(buf)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "cursor",
		row = 1,
		col = 0,
		width = utils.percentage_as_width(70),
		height = utils.percentage_as_height(40),
		border = "rounded",
		title = " " .. vim.fn.fnamemodify(vim.uri_to_fname(uri), ":~:.") .. " ",
		title_pos = "center",
	})
	state.win, state.buf = win, buf

	-- Moves the cursor to the definition, converting the LSP column to a byte column. `show_document` also lists the
	-- buffer, and it is listed on `<CR>` only, so the flag is put back.
	local listed = vim.bo[buf].buflisted
	vim.lsp.util.show_document(location, client.offset_encoding, { focus = true })
	vim.bo[buf].buflisted = listed
	vim.cmd("normal! zt")

	---Maps a key in the peek buffer, unless the buffer already has its own mapping for it
	local function map(key, fn, desc)
		if vim.fn.maparg(key, "n", false, true).buffer ~= 1 then
			vim.keymap.set("n", key, fn, { buf = buf, desc = desc })
			table.insert(state.mapped, key)
		end
	end

	map("q", M.close, "Close peek window")
	map("<Esc>", M.close, "Close peek window")
	map("<CR>", function()
		local cursor = vim.api.nvim_win_get_cursor(win)
		M.close()
		if not vim.api.nvim_win_is_valid(origin) then
			return
		end
		vim.api.nvim_set_current_win(origin)
		vim.cmd("normal! m'")
		vim.api.nvim_win_set_buf(origin, buf)
		vim.bo[buf].buflisted = true
		vim.api.nvim_win_set_cursor(origin, cursor)
		vim.cmd("normal! zv")
	end, "Open the peeked location in the window it was opened from")
end

---Opens the definition of the symbol under the cursor in a floating window
function M.definition()
	local buf = vim.api.nvim_get_current_buf()
	vim.lsp.buf_request_all(buf, "textDocument/definition", function(client)
		return vim.lsp.util.make_position_params(0, client.offset_encoding)
	end, function(results)
		-- The response arrived after the user moved to another buffer
		if vim.api.nvim_get_current_buf() ~= buf then
			return
		end
		local location, client = first_location(results)
		if not location or not client then
			vim.notify("No definition found", vim.log.levels.INFO)
			return
		end
		open(location, client)
	end)
end

local group = vim.api.nvim_create_augroup("Peek", { clear = true })

-- Closes the peek window when the cursor leaves it. The close is scheduled because a window cannot be closed while
-- nvim is leaving it. The check skips the close when another peek window replaced this one in the meantime.
vim.api.nvim_create_autocmd("WinLeave", {
	group = group,
	callback = function()
		local win = state.win
		if win and vim.api.nvim_get_current_win() == win then
			vim.schedule(function()
				if state.win == win then
					M.close()
				end
			end)
		end
	end,
})

-- Deletes the peek mappings when the window is closed another way, such as `:q`
vim.api.nvim_create_autocmd("WinClosed", {
	group = group,
	callback = function(ev)
		if tonumber(ev.match) == state.win then
			forget()
		end
	end,
})

return M
