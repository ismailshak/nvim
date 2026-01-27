local M = {}
local helpers = require("utils.helpers")
local api = require("utils.api")

---Dashboard section configuration
---@class DashboardSection
---@field lines table Array of line content
---@field padding number Lines of spacing after a section

---Dashboard action configuration
---@class DashboardAction
---@field icon string? Optional icon
---@field text string Display text
---@field keymap string Keyboard shortcut hint
---@field action function Action to execute on selection

---Build the dashboard configuration
---@return DashboardSection header
---@return DashboardAction[] actions
---@return DashboardSection footer
function M.build_config()
	local icons = require("utils.icons")
	local ui = require("utils.ui")

	local header = {
		lines = {
			"Neovim - v" .. helpers.nvim_version(),
		},
		padding = 4,
	}

	local actions = {
		{
			icon = icons.dashboard.session,
			text = "Load last session",
			keymap = "SPC s l",
			action = function()
				require("persistence").load({ last = true })
			end,
		},
		{
			icon = icons.dashboard.file,
			text = "Find file",
			keymap = "SPC f f",
			action = function()
				vim.cmd("FzfLua files")
			end,
		},
		{
			icon = icons.dashboard.word,
			text = "Find word",
			keymap = "SPC f g",
			action = function()
				vim.cmd("FzfLua live_grep")
			end,
		},
		{
			icon = icons.dashboard.branch,
			text = "Open diff",
			keymap = "SPC d v",
			action = function()
				vim.cmd("DiffviewOpen")
			end,
		},
		{
			icon = icons.copilot.response .. "  ",
			text = "Open copilot",
			keymap = "SPC c c",
			action = function()
				vim.cmd("CodeCompanionChat")
			end,
		},
		{
			icon = icons.dashboard.database,
			text = "Open database",
			keymap = "SPC b d",
			action = function()
				vim.cmd("DBUIToggle")
			end,
		},
		{
			icon = icons.dashboard.dotfile,
			text = "Open dotfile",
			keymap = "",
			action = function()
				vim.cmd("Dotfiles")
			end,
		},
	}

	local footer_lines = {}
	local dir_line = ui.build_dir_name_icon()
	table.insert(footer_lines, helpers.trim(dir_line))

	-- One line of padding between dir and git branch
	table.insert(footer_lines, "")

	local git_branch = api.get_git_branch()
	if git_branch ~= "" then
		table.insert(footer_lines, icons.statusline.git_branch .. " " .. git_branch)
	end

	local footer = {
		lines = footer_lines,
	}

	return header, actions, footer
end

---Format action items with consistent width
---@param actions DashboardAction[] Action items
---@param actions_item_spacing number Lines between action items
---@param keymap_spacing number Spaces between text and keymap
---@return string[] formatted_actions Display lines with spacing
---@return table<number, number> action_line_map Map of display line to action index
function M.format_actions(actions, actions_item_spacing, keymap_spacing)
	-- Calculate max width for "space-between" type of alignment
	local max_width = 0
	for _, action in ipairs(actions) do
		local full_text = (action.icon or "") .. action.text
		local total_width = vim.fn.strdisplaywidth(full_text) + vim.fn.strdisplaywidth(action.keymap) + keymap_spacing
		if total_width > max_width then
			max_width = total_width
		end
	end

	local formatted_actions = {} -- i.e. Actios are "space-between"'d (and any spacing lines between items)
	local action_line_map = {} -- Maps line number to action index (taking into account empty lines)

	for i, action in ipairs(actions) do
		local full_text = (action.icon or "") .. action.text
		local text_width = vim.fn.strdisplaywidth(full_text)
		local keymap_width = vim.fn.strdisplaywidth(action.keymap)
		local padding_needed = max_width - text_width - keymap_width
		local line = full_text .. string.rep(" ", padding_needed) .. action.keymap

		table.insert(formatted_actions, line)
		action_line_map[#formatted_actions] = i

		-- Add spacing between action items (except after last)
		if i < #actions then
			for _ = 1, actions_item_spacing do
				table.insert(formatted_actions, "")
			end
		end
	end

	return formatted_actions, action_line_map
end

---Assemble all sections into final layout
---@param header DashboardSection
---@param actions_display table Formatted action lines
---@param footer DashboardSection
---@param actions_bottom_padding number Spacing after actions section
---@return table all_lines Complete layout
---@return number actions_start_offset Line offset where actions begin
function M.assemble_layout(header, actions_display, footer, actions_bottom_padding)
	local all_lines = {}

	-- Add header
	vim.list_extend(all_lines, header.lines)
	for _ = 1, header.padding do
		table.insert(all_lines, "")
	end

	local actions_start_offset = #all_lines -- Just so we know where actions begin for cursor restriction reasons

	-- Add actions
	vim.list_extend(all_lines, actions_display)
	for _ = 1, actions_bottom_padding do
		table.insert(all_lines, "")
	end

	-- Add footer
	vim.list_extend(all_lines, footer.lines)

	return all_lines, actions_start_offset
end

---Calculate valid navigable line numbers
---@param action_line_map table<number, number> Map of display line to action index
---@param actions_start_offset number Offset where actions begin
---@param top_padding number Vertical centering padding
---@return number[] valid_lines Array of valid line numbers
---@return table<number, number> line_to_action_map Map of buffer line to action index
function M.calculate_valid_lines(action_line_map, actions_start_offset, top_padding)
	local valid_lines = {}
	local line_to_action_map = {}

	for action_line_number, action_idx in pairs(action_line_map) do
		-- `action_buffer_line` is the line number relative to the entire buffer (i.e. "buffer space" and not just the action section)
		local action_buffer_line = top_padding + actions_start_offset + action_line_number
		table.insert(valid_lines, action_buffer_line)
		line_to_action_map[action_buffer_line] = action_idx
	end

	table.sort(valid_lines) -- Ensure lines are in ascending order (since we used pairs above)
	return valid_lines, line_to_action_map
end

---Restrict cursor to valid content lines with proper column
---@param valid_lines table Array of valid line numbers
---@param actions DashboardAction[] Action items
---@param line_to_action_map table Map of buffer line to action index
---@param left_padding number Left padding of centered content
---@param last_valid_line number Previous valid line position
---@return number current_line New current line after restriction
function M.restrict_cursor(valid_lines, actions, line_to_action_map, left_padding, last_valid_line)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_line = cursor_pos[1]
	local current_col = cursor_pos[2]
	local buf_line_count = vim.api.nvim_buf_line_count(0)

	-- Make sure current line is within buffer bounds (if resizing caused it to go out of bounds)
	if current_line > buf_line_count then
		current_line = valid_lines[#valid_lines]
	end

	-- Check if current line is valid
	local is_valid = false
	for _, line in ipairs(valid_lines) do
		if line == current_line then
			is_valid = true
			break
		end
	end

	-- Calculate cursor column for current/target line (to be placed at the first character of text, after the icon)
	local function get_cursor_col(line_num)
		local action_idx = line_to_action_map[line_num]
		if action_idx and actions[action_idx] then
			local icon_width = #(actions[action_idx].icon or "")
			return left_padding + icon_width
		end
		return left_padding
	end

	-- If on invalid line, jump to next/prev valid line based on direction
	if not is_valid then
		local target_line = valid_lines[1]

		if current_line > last_valid_line then
			-- Moving down, find next valid line
			for _, line in ipairs(valid_lines) do
				if line > last_valid_line then
					target_line = line
					break
				end
			end
		else
			-- Moving up, find previous valid line
			for i = #valid_lines, 1, -1 do
				if valid_lines[i] < last_valid_line then
					target_line = valid_lines[i]
					break
				end
			end
		end

		-- Safety check before setting cursor
		if target_line <= buf_line_count then
			vim.api.nvim_win_set_cursor(0, { target_line, get_cursor_col(target_line) })
			return target_line
		end
		return last_valid_line
	else
		-- Move it to the correct column on the current valid line
		local correct_col = get_cursor_col(current_line)
		if current_col ~= correct_col then
			vim.api.nvim_win_set_cursor(0, { current_line, correct_col })
		end
		return current_line
	end
end

---Set up keybindings for menu items
---@param buf number Buffer handle
---@param actions DashboardAction[] Menu items
---@param line_to_action_map table Map of buffer line to item index
function M.setup_keymaps(buf, actions, line_to_action_map)
	-- Enter key executes current item's action
	api.nmap("<CR>", function()
		local current_line = vim.api.nvim_win_get_cursor(0)[1]
		local item_idx = line_to_action_map[current_line]
		if item_idx and actions[item_idx] then
			actions[item_idx].action()
		end
	end, "Trigger action on current line [dashboard]", { buffer = buf, silent = true })

	-- Disable visual mode
	api.nmap("v", "<Nop>", "", { buffer = buf, silent = true })
	api.nmap("V", "<Nop>", "", { buffer = buf, silent = true })
	api.nmap("<C-v>", "<Nop>", "", { buffer = buf, silent = true })
end

---Apply syntax highlighting to dashboard sections
---@param buf number Buffer handle
---@param actions DashboardAction[] Action items
---@param line_to_action_map table Map of buffer line to item index
---@param valid_lines table Array of valid line numbers
---@param footer DashboardSection Footer section
---@param all_lines table All layout lines before centering
---@param top_padding number Vertical centering padding
function M.apply_highlights(buf, actions, line_to_action_map, valid_lines, footer, all_lines, top_padding)
	local ns_id = vim.api.nvim_create_namespace("dashboard")

	-- Highlight icons and keymaps in action items
	for _, line_num in ipairs(valid_lines) do
		local action_idx = line_to_action_map[line_num]
		if action_idx and actions[action_idx] then
			local action = actions[action_idx]
			local line_text = vim.api.nvim_buf_get_lines(buf, line_num - 1, line_num, false)[1]

			-- Find where content starts (after left padding)
			local content_start = line_text:find("%S") - 1

			-- Highlight the icon
			if action.icon then
				local icon_len = #action.icon
				vim.api.nvim_buf_set_extmark(buf, ns_id, line_num - 1, content_start, {
					end_col = content_start + icon_len,
					hl_group = "DashboardIcon",
				})
			end

			-- Highlight keymap (at the end of the line)
			local keymap_start = line_text:len() - #action.keymap
			vim.api.nvim_buf_set_extmark(buf, ns_id, line_num - 1, keymap_start, {
				end_col = line_text:len(),
				hl_group = "DashboardKeymap",
			})
		end
	end

	-- Highlight footer
	-- Calculate where footer starts in the buffer
	local footer_start_line = top_padding + #all_lines - #footer.lines + 1
	for i = 0, #footer.lines - 1 do
		vim.api.nvim_buf_set_extmark(buf, ns_id, footer_start_line + i - 1, 0, {
			end_line = footer_start_line + i,
			hl_group = "DashboardFooter",
		})
	end
end

---Render the dashboard content
---@param buf number Buffer handle
function M.render(buf)
	local ACTION_ITEM_PADDING = 1 -- Lines between action items
	local ACTIONS_PADDING = 4 -- Lines after the actions section
	local KEYMAP_SPACING = 16 -- Spaces between action text and keymap (horizontal spacing)
	local LAYOUT_VERTICAL_OFFSET = 0.4 -- Percentage from top (0-1, where 0.5 = center, <0.5 = up, >0.5 = down)

	local header, actions, footer = M.build_config()

	local actions_display, action_line_map = M.format_actions(actions, ACTION_ITEM_PADDING, KEYMAP_SPACING)

	-- Assemble complete layout
	local all_lines, actions_start_offset = M.assemble_layout(header, actions_display, footer, ACTIONS_PADDING)

	-- Center and write to buffer
	vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
	local centered_lines, top_padding = M.center_lines(all_lines, LAYOUT_VERTICAL_OFFSET)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, centered_lines)
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

	-- Calculate valid navigable lines
	local valid_lines, line_to_action_map = M.calculate_valid_lines(action_line_map, actions_start_offset, top_padding)

	-- Calculate left padding (left edge of centered content)
	local rendered_line = vim.api.nvim_buf_get_lines(buf, valid_lines[1] - 1, valid_lines[1], false)[1]
	local left_padding = rendered_line:find("%S") - 1

	-- Apply syntax highlighting
	M.apply_highlights(buf, actions, line_to_action_map, valid_lines, footer, all_lines, top_padding)

	-- Set up keybindings
	M.setup_keymaps(buf, actions, line_to_action_map)

	-- Set up autocommands (includes cursor restriction)
	M.setup_autocommands(buf, valid_lines, actions, line_to_action_map, left_padding)

	-- Set initial cursor position (after first item's icon)
	local first_item_idx = line_to_action_map[valid_lines[1]]
	local first_icon = actions[first_item_idx].icon or ""
	vim.api.nvim_win_set_cursor(0, { valid_lines[1], left_padding + #first_icon })
end

---Center lines vertically and horizontally
---@param lines table Lines to center
---@param vertical_offset number? Percentage offset from center (0-1, where 0.5 = center, <0.5 = up, >0.5 = down)
---@return table centered Centered lines
---@return number top_offset Number of padding lines added at the top
function M.center_lines(lines, vertical_offset)
	vertical_offset = vertical_offset or 0.5 -- Default to center (50%)
	local win_height = vim.api.nvim_win_get_height(0)
	local win_width = vim.api.nvim_win_get_width(0)

	local centered = {}

	-- Calculate vertical padding based on percentage
	local content_height = #lines
	local available_height = win_height - content_height

	-- Convert percentage to actual line offset
	local top_offset = math.floor(available_height * vertical_offset)

	-- Protect against negative offsets
	top_offset = math.max(0, top_offset)

	-- Add the empty lines above for top padding
	for _ = 1, top_offset do
		table.insert(centered, "")
	end

	-- Center each line horizontally
	for _, line in ipairs(lines) do
		local padding = math.floor((win_width - vim.fn.strdisplaywidth(line)) / 2)
		table.insert(centered, string.rep(" ", padding) .. line)
	end

	return centered, top_offset
end

---Set up autocommands for dashboard behavior
---@param buf number Buffer handle
---@param valid_lines table Array of valid line numbers
---@param actions DashboardAction[] Action items
---@param line_to_action_map table Map of buffer line to action index
---@param left_padding number Left padding of centered content
function M.setup_autocommands(buf, valid_lines, actions, line_to_action_map, left_padding)
	-- Clear existing autocommands for this buffer since we'll be calling this on re-render
	local augroup = vim.api.nvim_create_augroup("Dashboard_" .. buf, { clear = true })

	-- Track last valid line for cursor restriction
	local last_valid_line = valid_lines[1]

	-- Restrict cursor movement to valid action items
	vim.api.nvim_create_autocmd("CursorMoved", {
		buffer = buf,
		group = augroup,
		callback = function()
			-- Verify buffer is still valid
			if not vim.api.nvim_buf_is_valid(buf) then
				return true -- Remove autocmd
			end

			last_valid_line = M.restrict_cursor(valid_lines, actions, line_to_action_map, left_padding, last_valid_line)
		end,
	})

	-- Re-render on window resize to maintain centering
	vim.api.nvim_create_autocmd("VimResized", {
		buffer = buf,
		group = augroup,
		callback = function()
			M.render(buf)
		end,
	})
end

function M.open()
	local buffer = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_set_option_value("buftype", "nofile", { buf = buffer })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buffer })
	vim.api.nvim_set_option_value("swapfile", false, { buf = buffer })
	vim.api.nvim_set_option_value("buflisted", false, { buf = buffer })
	vim.api.nvim_set_option_value("filetype", "dashboard", { buf = buffer })
	vim.api.nvim_set_option_value("undofile", false, { buf = buffer })
	vim.api.nvim_set_option_value("undolevels", -1, { buf = buffer })

	vim.api.nvim_set_current_buf(buffer)

	M.render(buffer)

	-- Hide all UI elements
	vim.opt_local.number = false
	vim.opt_local.relativenumber = false
	vim.opt_local.signcolumn = "no"
	vim.opt_local.foldcolumn = "0"
	vim.opt_local.statusline = ""
	vim.opt_local.cursorline = false
end

return M
