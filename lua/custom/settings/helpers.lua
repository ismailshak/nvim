local utils = require("utils.helpers")
local TAB, NEW_LINE = "   ", "\n"

local M = {}

---Create the local settings file (that's gitignored)
---@return string path Absolute path to local settings file
M.create_local = function()
	local local_path = utils.module_to_path("custom.settings.local")
	local template_path = utils.module_to_path("custom.settings.defaults")
	if M.local_exists() then
		return local_path
	end

	utils.clone_file(template_path, local_path)
	print("Local settings created")
	return local_path
end

---Create local settings file if it doesn't already exist
---@return string|nil path Absolute path to local settings file
M.assert_local = function()
	local local_path = M.create_local()

	if not M.local_exists() then
		print("WARNING: Failed to create local settings file")
		return nil
	end

	return local_path
end

---Checks if local settings file exists and can be required
---@return boolean
M.local_exists = function()
	return utils.exists("custom.settings.local")
end

---Formats a key value pair into a format that can be written to a file
---@param k string Key in table
---@param v string Value in table
---@return string
M.format_setting = function(k, v)
	return TAB .. utils.wrap_string(k, '["', '"]') .. " = " .. v .. "," .. NEW_LINE
end

---Save an in-memory settings table into a file
---@see docs https://lua-users.org/wiki/SaveTableToFile
---@param table Settings
---@param file_path? string Path to file
---@return string|nil
M.save = function(table, file_path)
	local fp = file_path or utils.module_to_path("custom.settings.local")
	local file, err = io.open(fp, "wb")
	if err or file == nil then
		print("Error loading local settings")
		print(vim.inspect(err))
		return nil
	end

	file:write("---@type Settings" .. NEW_LINE)
	file:write("local M = {" .. NEW_LINE)

	for k, v in pairs(table) do
		local stype = type(v)
		if stype == "table" then
			print("WARNING: nested settings aren't supported yet:", k)
		elseif stype == "string" then
			file:write(M.format_setting(k, utils.wrap_string(v)))
		elseif stype == "number" then
			file:write(M.format_setting(k, tostring(v)))
		end
	end

	file:write("}" .. NEW_LINE)
	file:write(NEW_LINE)
	file:write("return M")
	file:close()
end

---Load local settings content
---@see docs https://lua-users.org/wiki/SaveTableToFile
---@param file_path? string Path to file
---@return Settings|nil
M.load = function(file_path)
	if file_path ~= nil then
		local ftables, err = loadfile(file_path)
		if err or ftables == nil then
			print("Error loading local settings")
			print(vim.inspect(err))
			return nil
		end
		local tables = ftables()
		return tables
	end

	local settings = require("custom.settings.local")
	return settings
end

---Merge local and default settings
---@param default Settings
---@param _local Settings
---@return Settings
M.merge_settings = function(default, _local)
	return utils.merge_tables(_local, default)
end

return M
