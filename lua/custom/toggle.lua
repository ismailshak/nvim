local M = {}
local api = require("utils.api")

local state = {
	buf = nil,
	win = nil,
	origin_buf = nil,
}

M.config = {
	toggles = {
		{
			key = "d",
			label = "Show diagnostics",
			get_state = function()
				return vim.diagnostic.is_enabled()
			end,
			toggle = function()
				vim.diagnostic.enable(not vim.diagnostic.is_enabled())
			end,
		},
		{
			key = "h",
			label = "LSP inlay hints",
			get_state = function()
				return vim.lsp.inlay_hint.is_enabled({ bufnr = state.origin_buf })
			end,
			toggle = function()
				local filter = { bufnr = state.origin_buf }
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
			end,
		},
		{
			key = "t",
			label = "Treesitter highlighting",
			get_state = function()
				return vim.treesitter.highlighter.active[state.origin_buf] ~= nil
			end,
			toggle = function()
				if vim.treesitter.highlighter.active[state.origin_buf] ~= nil then
					vim.treesitter.stop(state.origin_buf)
				else
					vim.treesitter.start(state.origin_buf)
				end
			end,
		},
		{
			key = "f",
			label = "Format on save",
			get_state = function()
				return vim.g.format_on_save or false
			end,
			toggle = function()
				vim.g.format_on_save = not vim.g.format_on_save
			end,
		},
		{
			key = "i",
			label = "Indent guides",
			get_state = function()
				return require("ibl.config").get_config(state.origin_buf).enabled
			end,
			toggle = function()
				require("ibl").setup_buffer(state.origin_buf, {
					enabled = not require("ibl.config").get_config(state.origin_buf).enabled,
				})
			end,
		},
	},
	window = {
		width = 30,
		border = "rounded",
		title = "Settings",
		margin = { top = 1, right = 4 },
	},
	icons = {
		enabled = "",
		disabled = "",
	},
}

---Creates and configures the toggle window
local function create_window()
	local height = #M.config.toggles + 2
	local width = M.config.window.width
	state.origin_buf = vim.api.nvim_get_current_buf()

	local current_win = vim.api.nvim_get_current_win()
	local win_width = vim.api.nvim_win_get_width(current_win)

	local col = win_width - width - M.config.window.margin.right
	local row = M.config.window.margin.top

	state.buf = vim.api.nvim_create_buf(false, true)

	vim.bo[state.buf].buftype = "nofile"
	vim.bo[state.buf].bufhidden = "wipe"
	vim.bo[state.buf].swapfile = false
	vim.bo[state.buf].buflisted = false
	vim.bo[state.buf].filetype = "toggle"
	vim.bo[state.buf].undofile = false
	vim.bo[state.buf].undolevels = -1

	local opts = {
		relative = "win",
		win = current_win,
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = M.config.window.border,
		title = M.config.window.title,
		title_pos = "center",
	}

	state.win = vim.api.nvim_open_win(state.buf, true, opts)

	vim.wo[state.win].winblend = 0
	vim.wo[state.win].cursorline = true
end

---Renders the toggle options including highlighting
local function render()
	if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
		return
	end

	local lines = {}
	local width = M.config.window.width

	for _, toggle in ipairs(M.config.toggles) do
		local state_val = toggle.get_state()
		local state_icon = state_val and M.config.icons.enabled or M.config.icons.disabled
		local left_part = string.format("%s %s", toggle.key, toggle.label)
		local padding = width - vim.fn.strwidth(left_part) - vim.fn.strwidth(state_icon) - 2
		local line = string.format("%s%s%s", left_part, string.rep(" ", padding), state_icon)
		table.insert(lines, line)
	end

	vim.bo[state.buf].modifiable = true
	vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
	vim.bo[state.buf].modifiable = false

	local ns_id = vim.api.nvim_create_namespace("toggle_window")
	vim.api.nvim_buf_clear_namespace(state.buf, ns_id, 0, -1)

	for i, toggle in ipairs(M.config.toggles) do
		local state_val = toggle.get_state()
		vim.api.nvim_buf_set_extmark(state.buf, ns_id, i - 1, 0, {
			end_col = 1,
			hl_group = "Special",
		})
		local line = lines[i]
		local line_len = #line
		local icon_width = vim.fn.strwidth(state_val and M.config.icons.enabled or M.config.icons.disabled)
		local icon_start = line_len - icon_width
		local hl = state_val and "String" or "Comment"
		vim.api.nvim_buf_set_extmark(state.buf, ns_id, i - 1, icon_start, {
			end_col = line_len,
			hl_group = hl,
		})
	end
end

---Toggles the setting corresponding to the currently selected line
local function toggle_current()
	local line = vim.api.nvim_win_get_cursor(state.win)[1]
	local toggle = M.config.toggles[line]

	if toggle then
		toggle.toggle()
		render()
	end
end

----Finds and toggles a settings based on the pressed key
local function toggle_by_key(key)
	for _, toggle in ipairs(M.config.toggles) do
		if toggle.key == key then
			toggle.toggle()
			render()
			return
		end
	end
end

local function setup_keymaps()
	local opts = { buffer = state.buf, nowait = true, silent = true }

	api.nmap("q", M.close, "Close settings window", opts)
	api.nmap("<Esc>", M.close, "Close settings window", opts)
	api.nmap("<CR>", toggle_current, "Toggle current setting", opts)

	for _, toggle in ipairs(M.config.toggles) do
		api.nmap(toggle.key, function()
			toggle_by_key(toggle.key)
		end, "Toggle setting assigned to " .. toggle.key, opts)
	end
end

---Open the settings window. Does nothing if it's already open.
function M.open()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		return
	end

	create_window()
	render()
	setup_keymaps()
end

---Closes the settings window if it's open
function M.close()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_close(state.win, true)
	end

	state.win = nil
	state.buf = nil
	state.origin_buf = nil
end

---Toggles the settings window open or closed based on its current state
function M.toggle()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		M.close()
	else
		M.open()
	end
end

return M
