local utils = require("utils.helpers")
local TAB, NEW_LINE = "   ", "\n"

local M = {}

---Create the local settings file (that's gitignored)
---@return string path Absolute path to local settings file
function M.create_local()
	local local_path = utils.module_to_path("custom.settings.local")
	local template_path = utils.module_to_path("custom.settings.defaults")
	if M.local_exists() then
		return local_path
	end

	utils.clone_file(template_path, local_path)
	vim.notify("Local settings created")
	return local_path
end

---Create local settings file if it doesn't already exist
---@return string|nil path Absolute path to local settings file
function M.assert_local()
	local local_path = M.create_local()

	if not M.local_exists() then
		print("WARNING: Failed to create local settings file")
		return nil
	end

	return local_path
end

---Checks if local settings file exists and can be required
---@return boolean
function M.local_exists()
	return utils.exists("custom.settings.local")
end

---Formats a key value pair into a format that can be written to a file
---@param k string Key in table
---@param v string Value in table
---@return string
function M.format_setting(k, v)
	return TAB .. utils.wrap_string(k, '["', '"]') .. " = " .. v .. "," .. NEW_LINE
end

---Converts an in-memory table (with nested tables) into a string
---@param tbl table Table to convert
---@param indent string Current indentation level
---@return string
function M.table_to_string(tbl, indent)
	local str = ""
	local is_array = tbl[1] ~= nil
	for k, v in pairs(tbl) do
		local formatting = indent .. (is_array and "" or '["' .. k .. '"]' .. " = ")
		if type(v) == "table" then
			str = str
				.. formatting
				.. "{"
				.. NEW_LINE
				.. M.table_to_string(v, indent .. TAB)
				.. indent
				.. "},"
				.. NEW_LINE
		else
			local quote = type(v) == "string" and '"' or ""
			str = str .. formatting .. quote .. tostring(v) .. quote .. "," .. NEW_LINE
		end
	end
	return str
end

---Save an in-memory settings table into a file
---@see docs https://lua-users.org/wiki/SaveTableToFile
---@param table Settings
---@param file_path? string Path to file
---@return nil
function M.save(table, file_path)
	local fp = file_path or utils.module_to_path("custom.settings.local")
	local file, err = io.open(fp, "wb")
	if err or file == nil then
		print("Error loading local settings")
		print(vim.inspect(err))
		return nil
	end

	file:write("---@type Settings" .. NEW_LINE)
	file:write("local M = {" .. NEW_LINE)
	file:write(M.table_to_string(table, TAB))
	file:write("}" .. NEW_LINE)
	file:write(NEW_LINE)
	file:write("return M")
	file:close()
end

---Load local settings content
---@see docs https://lua-users.org/wiki/SaveTableToFile
---@param file_path? string Path to file
---@return Settings|nil
function M.load(file_path)
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
---@param d Settings Default settings
---@param l Settings Local settings
---@return Settings
function M.merge_settings(d, l)
	return utils.merge_tables(d, l)
end

return M
