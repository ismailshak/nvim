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

return M
