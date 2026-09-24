local api = require("utils.api")

---Deletes the items on the selected lines from the list shown in the current window, which is either the quickfix
---list or the window's location list. In normal mode the selection is the cursor line.
local function remove_items()
	local win = vim.api.nvim_get_current_win()
	local is_loclist = vim.fn.getwininfo(win)[1].loclist == 1
	local items = is_loclist and vim.fn.getloclist(0) or vim.fn.getqflist()
	if #items == 0 then
		return
	end

	-- `line("v")` is the cursor line in normal mode, so the range is then a single line
	local first = math.min(vim.fn.line("v"), vim.fn.line("."))
	local last = math.max(vim.fn.line("v"), vim.fn.line("."))
	for i = last, first, -1 do
		table.remove(items, i)
	end

	if is_loclist then
		vim.fn.setloclist(0, items, "r")
		vim.cmd("lopen")
	else
		vim.fn.setqflist(items, "r")
		vim.cmd("copen")
	end

	-- An empty list has no line to put the cursor on
	if #items == 0 then
		return
	end
	vim.api.nvim_win_set_cursor(win, { math.min(last, #items), 0 })
end

api.xmap("d", remove_items, "Delete selected items from the list", { buf = 0 })
api.nmap("dd", remove_items, "Delete item under cursor from the list", { buf = 0 })
