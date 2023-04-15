local M = {}

---Split string by delimiter
---@param inputstr string
---@param sep string
---@return string[]
M.split = function(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

---Trim string
---@param str string
---@return string
M.trim = function(str)
	return (str:gsub("^%s*(.-)%s*$", "%1"))
end

---Checks if module exists
---@param module string Name of module
---@return boolean
M.exists = function(module)
	local ok, _ = pcall(require, module)
	return ok
end

---Toggle background between "dark" & "light"
---@alias background '"dark"' | '"light"'
---@return background string Value after toggle
M.toggle_bg = function()
	local dark = "dark"
	local light = "light"
	if vim.opt.background:get() == dark then
		vim.opt.background = light
		return light
	end

	vim.opt.background = "dark"
	return dark
end

---Total number of recognized plugins
---@return number
M.get_plugin_count = function()
	if M.exists("lazy") then
		return require("lazy").stats().count
	end

	return 0
end

---Total number of plugins actually loaded
---@return number
M.get_loaded_plugin_count = function()
	if M.exists("lazy") then
		return require("lazy").stats().count
	end

	return 0
end

---Create a highlight group
---@param name string Highlight group
---@param value string|table Color to assign to group
---@return nil
M.hi = function(name, value)
	vim.api.nvim_set_hl(0, name, value)
end

---Returns default options given to keymap definitions
---@param desc string
---@return table
M.get_default_opts = function(desc)
	return { noremap = true, desc = desc or "", silent = true }
end

---Base function that creates a mapping between key and command
---@param mode string See :h map-listing for chars
---@param key string The key used in the mapping
---@param binding string The command to bind to the mapping
---@param desc string The description will be added to the mapping for context/search
---@param opts? table Any options you can pass to the underlying keymap api
M.map = function(mode, key, binding, desc, opts)
	local base = M.get_default_opts(desc)
	for k, v in pairs(opts or {}) do
		base[k] = v
	end -- merge base with incoming opts

	vim.keymap.set(mode, key, binding, base)
end

---Creates a normal-mode-only mapping
---@param key string The key used in the mapping
---@param binding string The command to bind to the mapping
---@param desc string The description will be added to the mapping for context/search
---@param opts? table Any options you can pass to the underlying keymap api
M.nmap = function(key, binding, desc, opts)
	M.map("n", key, binding, desc, opts)
end

---Creates a visual-mode-only mapping
---@param key string The key used in the mapping
---@param binding string The command to bind to the mapping
---@param desc string The description will be added to the mapping for context/search
---@param opts? table Any options you can pass to the underlying keymap api
M.vmap = function(key, binding, desc, opts)
	M.map("v", key, binding, desc, opts)
end

---Creates a insert-mode-only mapping
---@param key string The key used in the mapping
---@param binding string The command to bind to the mapping
---@param desc string The description will be added to the mapping for context/search
---@param opts? table Any options you can pass to the underlying keymap api
M.imap = function(key, binding, desc, opts)
	M.map("i", key, binding, desc, opts)
end

---Creates a terminal-mode-only mapping
---@param key string The key used in the mapping
---@param binding string The command to bind to the mapping
---@param desc string The description will be added to the mapping for context/search
---@param opts? table Any options you can pass to the underlying keymap api
M.tmap = function(key, binding, desc, opts)
	M.map("t", key, binding, desc, opts)
end

return M
