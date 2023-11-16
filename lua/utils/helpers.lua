local M = {}

---Return the current working directory
---@return string
function M.cwd()
	return vim.fn.getcwd()
end

---Split string by delimiter
---@param inputstr string
---@param sep string
---@return string[]
function M.split(inputstr, sep)
	return vim.split(inputstr, sep)
end

---Join items in table into a string
---@param tbl table
---@param sep string
---@return string
function M.join(tbl, sep)
	return tbl.concat(tbl, sep)
end

---Trim whitespace characters in string
---@param str string
---@return string
function M.trim(str)
	return M.replace(str, "^%s*(.-)%s*$", "%1")
end

---Checks if Lua module exists
---@param module string Name of module
---@return boolean
function M.exists(module)
	local ok, _ = pcall(require, module)
	return ok
end

---String replacement function
---@see docs https://www.lua.org/manual/5.1/manual.html#5.4.1
---@param str string String with content to replace
---@param pattern string The pattern to replace
---@param replacement string The replacement string
---@return string
function M.replace(str, pattern, replacement)
	return (str:gsub(pattern, replacement))
end

---Wrap a string with characters
---@param str string
---@param left? string The character to use for the left wrap. Default '"'
---@param right? string The character to use for the right wrap. Default '"'
---@return string
function M.wrap_string(str, left, right)
	local l, r = left or '"', right or '"'
	return l .. str .. r
end

---Check if value exists in table
---@param tbl table
---@param value string|number
---@return boolean
function M.contains(tbl, value)
	return vim.tbl_contains(tbl, value)
end

---Merge two tables, prioratizing right most in list of params
---@param ... table Tables to merge
---@return table result Merged table
function M.merge_tables(...)
	return vim.tbl_deep_extend("force", ...)
end

---Format config module require path to an absolute path for the file
---@param module string Lua-require module path (module in nvim config)
---@return string
function M.module_to_path(module)
	local config_root = vim.fn.stdpath("config")
	-- TODO: handle paths better
	return config_root .. "/lua/" .. M.replace(module, "%.", "/") .. ".lua"
end

---Clone a file
---@param path string Source path
---@param new_path string Destination path (including rename)
---@return string path Path to new file
function M.clone_file(path, new_path)
	vim.fn.jobstart({ "cp", path, new_path }, {
		on_stderr = function(_, data)
			print("Error `cp`-ing file")
			print(data)
		end,
	})
	return new_path
end

---Deep clone a Lua table
---@param table table
---@return table
function M.deep_clone(table)
	return vim.deepcopy(table)
end

---Check if string includes substring
---@param str string
---@param substr string
---@return boolean
function M.includes(str, substr)
	return string.find(str, substr) ~= nil
end

return M
