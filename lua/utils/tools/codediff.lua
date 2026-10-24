local M = {}

-- Names for the merge stages git keeps in the index during a conflict
local MERGE_STAGES = {
	[":1"] = "Base",
	[":2"] = "Ours (Current)",
	[":3"] = "Theirs (Incoming)",
}

---Returns the revision of a file codediff read from git, shortened for display: "index" for the staged version, the
---merge stage name during a conflict, the first 7 characters of a commit hash, or the ref as written. Returns nil for
---any other buffer.
---@param bufnr integer
---@return string?
function M.revision(bufnr)
	-- codediff names a file read from git codediff:///<repository root>///<revision>/<path in the repository>
	local revision = vim.api.nvim_buf_get_name(bufnr):match("^codediff:///.-///([^/]+)/")
	if revision == ":0" then
		return "index"
	elseif MERGE_STAGES[revision] then
		return MERGE_STAGES[revision]
	elseif revision and revision:match("^%x+$") then
		return revision:sub(1, 7)
	end
	return revision
end

---Renders barbecue's winbar on every pane of a codediff tab. codediff clears the winbars of the two diff panes on
---every window and buffer change, so that a winbar on one pane does not push its lines out of line with the other.
---barbecue's own autocmds then render only the current window. Rendering all of them keeps the panes aligned.
---@param tabpage integer
local function update_winbars(tabpage)
	-- get_session is not in codediff's documented API. lazy-lock.json pins the version this was written against.
	local session = require("codediff.ui.lifecycle").get_session(tabpage)
	if session == nil then
		return
	end

	local barbecue = require("barbecue.ui")
	-- An added or deleted file has only one diff pane, and only the merge conflict view has a result pane. The
	-- missing windows are nil.
	local panes = { original = session.original_win, modified = session.modified_win, result = session.result_win }
	for _, win in pairs(panes) do
		if vim.api.nvim_win_is_valid(win) then
			barbecue.update(win)
		end
	end
end

function M.setup_winbars()
	local group = vim.api.nvim_create_augroup("CodeDiffWinbars", { clear = true })
	local function schedule_update_winbars()
		-- Scheduled so it runs after codediff's own autocmds for the same event clear the winbars
		vim.schedule(function()
			update_winbars(vim.api.nvim_get_current_tabpage())
		end)
	end
	vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter", "WinEnter", "FileType" }, {
		group = group,
		callback = schedule_update_winbars,
	})
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = { "CodeDiffOpen", "CodeDiffFileSelect" },
		callback = schedule_update_winbars,
	})
end

---Opens codediff on the argument list: the repository's changes when it is empty, otherwise its two files or two
---directories. codediff's q quits nvim, because this is for starting nvim from the shell, as in `nvim a b +DiffArgs`.
---The paths are read from the argument list because :CodeDiff splits a typed argument string on spaces in file names.
function M.diff_args()
	local argc = vim.fn.argc()
	if argc ~= 0 and argc ~= 2 then
		vim.notify(string.format("DiffArgs needs 0 or 2 paths in the argument list, got %d", argc), vim.log.levels.ERROR)
		return
	end

	-- persistence.nvim would save this nvim as the session for the working directory when it quits
	require("persistence").stop()

	if argc == 0 then
		vim.cmd.CodeDiff("--exit-on-close")
		return
	end

	local a, b = vim.fn.argv(0), vim.fn.argv(1)
	local mode = (vim.fn.isdirectory(a) == 1 and vim.fn.isdirectory(b) == 1) and "dir" or "file"
	vim.cmd.CodeDiff({ args = { "--exit-on-close", mode, a, b } })
end

return M
