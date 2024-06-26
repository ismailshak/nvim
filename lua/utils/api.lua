---@diagnostic disable: inject-field
local settings = require("custom.settings")
local utils = require("utils.helpers")

local M = {}

---@alias os 'macos'|'linux'|'windows'

---Get OS name
---@return os
function M.get_os()
	local os_id = vim.loop.os_uname().sysname
	if os_id == "Darwin" then
		return "macos"
	elseif os_id == "Linux" then
		return "linux"
	elseif os_id == "Windows" then
		return "windows"
	end

	error("Unsupported OS: " .. os_id)
end

---Set background to "dark" or "light"
---@param value background
---@return background
function M.set_bg(value)
	vim.opt.background = value
	return value
end

---Toggle background between "dark" & "light"
---@return background string Value after toggle
function M.toggle_bg()
	if vim.o.background == "dark" then
		return M.set_bg("light")
	end

	return M.set_bg("dark")
end

---Save colorscheme to local settings
---@param colorscheme? string Color scheme to save
function M.save_colorscheme(colorscheme)
	local s = settings.get()
	local current_theme = colorscheme or vim.cmd("colorscheme")
	if s.theme == current_theme then
		return
	end

	s.theme = current_theme or ""
	settings.update(s)
end

---Total number of recognized plugins
---@return number
function M.get_plugin_count()
	if utils.exists("lazy") then
		return require("lazy").stats().count
	end

	return 0
end

---Total number of plugins actually loaded
---@return number
function M.get_loaded_plugin_count()
	if utils.exists("lazy") then
		return require("lazy").stats().loaded
	end

	return 0
end

---Get the current system background
---@return background
function M.get_system_background()
	if M.get_os() ~= "macos" then
		return "dark"
	end

	local output = vim.fn.system("defaults read -g AppleInterfaceStyle")
	if utils.includes(output, "Dark") then
		return "dark"
	end

	return "light"
end

---Get current git branch
---@return string
function M.get_git_branch()
	return vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
end

---Detects if Neovim is embedded in VSCode
---@return boolean
function M.is_vscode()
	return vim.g.vscode
end

---Get the components of a highlight group by highlignt name
---@param highlight string
function M.get_highlight(highlight)
	local hi = vim.api.nvim_get_hl(0, { name = highlight })

	local f = {}

	if hi.fg then
		f.fg = string.format("#%06x", hi.fg)
	end

	if hi.bg then
		f.bg = string.format("#%06x", hi.bg)
	end

	return f
end

---Create a highlight group
---@param name string Highlight group
---@param value table Color to assign to group
function M.hi(name, value)
	vim.api.nvim_set_hl(0, name, value)
end

---Returns default options given to keymap definitions
---@param desc string
---@return table
function M.get_default_opts(desc)
	return { noremap = true, desc = desc or "", silent = true }
end

---Define an abbreviation for insert mode
---@param lhs string The abbreviation
---@param rhs string The expansion
function M.iabbr(lhs, rhs)
	vim.cmd("iabbrev " .. lhs .. " " .. rhs)
end

---Define an abbreviation for command mode
---@param lhs string The abbreviation
---@param rhs string The expansion
function M.cabbr(lhs, rhs)
	vim.cmd("cabbrev " .. lhs .. " " .. rhs)
end

---Base function that creates a mapping between key and command
---@param mode string|table See :h map-listing for chars
---@param key string The key used in the mapping
---@param binding string|function The command to bind to the mapping
---@param desc string The description will be added to the mapping for context/search
---@param opts? table Any options you can pass to the underlying keymap api
function M.map(mode, key, binding, desc, opts)
	local base = M.get_default_opts(desc)
	for k, v in pairs(opts or {}) do
		base[k] = v
	end -- merge base with incoming opts

	vim.keymap.set(mode, key, binding, base)
end

---Creates a normal-mode-only mapping
---@param key string The key used in the mapping
---@param binding string|function The command to bind to the mapping
---@param desc string The description will be added to the mapping for context/search
---@param opts? table Any options you can pass to the underlying keymap api
function M.nmap(key, binding, desc, opts)
	M.map("n", key, binding, desc, opts)
end

---Creates a visual-mode-only mapping
---@param key string The key used in the mapping
---@param binding string|function The command to bind to the mapping
---@param desc string The description will be added to the mapping for context/search
---@param opts? table Any options you can pass to the underlying keymap api
function M.vmap(key, binding, desc, opts)
	M.map("v", key, binding, desc, opts)
end

---Creates a insert-mode-only mapping
---@param key string The key used in the mapping
---@param binding string|function The command to bind to the mapping
---@param desc string The description will be added to the mapping for context/search
---@param opts? table Any options you can pass to the underlying keymap api
function M.imap(key, binding, desc, opts)
	M.map("i", key, binding, desc, opts)
end

---Creates a terminal-mode-only mapping
---@param key string The key used in the mapping
---@param binding string|function The command to bind to the mapping
---@param desc string The description will be added to the mapping for context/search
---@param opts? table Any options you can pass to the underlying keymap api
function M.tmap(key, binding, desc, opts)
	M.map("t", key, binding, desc, opts)
end

return M
