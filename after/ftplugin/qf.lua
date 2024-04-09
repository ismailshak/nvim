local api = require("utils.api")

local function remove_qf_item()
	local start_line = vim.fn.line("v") -- Will be nil in normal mode
	local end_line = vim.fn.line(".")
	local qf_items = vim.fn.getqflist()

	-- Return if there are no items to remove
	if #qf_items == 0 then
		return
	end

	-- Determine the range of lines to remove
	local remove_start, remove_end
	if start_line and end_line then
		remove_start = math.min(start_line, end_line)
		remove_end = math.max(start_line, end_line)
	elseif start_line then
		remove_start = start_line
		remove_end = start_line
	else
		return
	end

	-- Remove the items from the quickfix list in reverse order
	for i = remove_end, remove_start, -1 do
		table.remove(qf_items, i)
	end

	-- Update the quickfix list
	vim.fn.setqflist(qf_items, "r") -- "r" = replace

	-- Reopen quickfix window to refresh the list
	vim.cmd("copen")

	-- Determine the new cursor position
	local new_index = math.min(end_line, #qf_items)

	-- Set the cursor position directly in the quickfix window
	local winid = vim.fn.win_getid() -- Get the window ID of the quickfix window
	vim.api.nvim_win_set_cursor(winid, { new_index, 0 })
end

api.vmap("d", remove_qf_item, "Delete selected items from quick fix list", { buffer = true })
api.nmap("dd", remove_qf_item, "Delete item under cursor from quick fix list", { buffer = true })
