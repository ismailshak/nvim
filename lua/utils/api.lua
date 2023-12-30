---@diagnostic disable: inject-field
local settings = require("custom.settings")
local utils = require("utils.helpers")

local M = {}

---Get OS name
---@alias os 'macos'|'linux'|'windows'
---@return os
function M.get_os()
	local os = vim.loop.os_uname().sysname
	if os == "Darwin" then
		return "macos"
	elseif os == "Linux" then
		return "linux"
	elseif os == "Windows" then
		return "windows"
	end

	error("Unsupported OS: " .. os)
end

---Set background to "dark" or "light"
---@param value background
function M.set_bg(value)
	vim.opt.background = value
	return value
end

---Toggle background between "dark" & "light"
---@return background string Value after toggle
function M.toggle_bg()
	if vim.opt.background:get() == "dark" then
		return M.set_bg("light")
	end

	return M.set_bg("dark")
end

---Save colorscheme to local settings
---@param colorscheme? string Color scheme to save
function M.save_colorscheme(colorscheme)
	local s = settings.get()
	local current_theme = colorscheme or vim.api.nvim_exec("color", {})
	if s.theme == current_theme then
		return
	end

	s.theme = current_theme
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

---Create a highlight group
---@param name string Highlight group
---@param value table Color to assign to group
---@return nil
function M.hi(name, value)
	vim.api.nvim_set_hl(0, name, value)
end

---Returns default options given to keymap definitions
---@param desc string
---@return table
function M.get_default_opts(desc)
	return { noremap = true, desc = desc or "", silent = true }
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
