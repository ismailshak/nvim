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

---Trim whitespace characters in string
---@param str string
---@return string
M.trim = function(str)
	return M.replace(str, "^%s*(.-)%s*$", "%1")
end

---Checks if Lua module exists
---@param module string Name of module
---@return boolean
M.exists = function(module)
	local ok, _ = pcall(require, module)
	return ok
end

---String replacement function
---@see docs https://www.lua.org/manual/5.1/manual.html#5.4.1
---@param str string String with content to replace
---@param pattern string The pattern to replace
---@param replacement string The replacement string
---@return string
M.replace = function(str, pattern, replacement)
	return (str:gsub(pattern, replacement))
end

---Wrap a string with characters
---@param str string
---@param left? string The character to use for the left wrap. Default '"'
---@param right? string The character to use for the right wrap. Default '"'
---@return string
M.wrap_string = function(str, left, right)
	local l, r = left or '"', right or '"'
	return l .. str .. r
end

---Merge two tables, prioratizing one over the other
---@param priority table Table that takes precedence
---@param base table Bast table
---@return table
M.merge_tables = function(priority, base)
	local base_t = base or {}
	for k, v in pairs(priority or {}) do
		base_t[k] = v
	end -- merge priority into base

	return base_t
end

---Format config module require path to an absolute path for the file
---@param module string Lua-require module path (module in nvim config)
---@return string
M.module_to_path = function(module)
	local config_root = vim.fn.stdpath("config")
	-- TODO: handle paths better
	return config_root .. "/lua/" .. M.replace(module, "%.", "/") .. ".lua"
end

---Clone a file
---@param path string Source path
---@param new_path string Destination path (including rename)
---@return string path Path to new file
M.clone_file = function(path, new_path)
	vim.fn.jobstart({ "cp", path, new_path }, {
		on_stderr = function(_, data)
			print("Error `cp`-ing file")
			print(data)
		end,
	})
	return new_path
end

return M
