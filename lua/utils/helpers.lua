local M = {}

---Return the current neovim version
---@return string version in the form of X.X.X
function M.nvim_version()
	return vim.fn.execute("version"):match("v(%d+%.%d+%.%d+)")
end

---Return the current working directory
---@return string
function M.cwd()
	return vim.fn.getcwd()
end

---Returns true if the executable was found on the system
---@param executable string
---@return boolean
function M.which(executable)
	return vim.fn.executable(executable) == 1
end

---Return the absolute path of the current file
---@return string
function M.full_path()
	return vim.fn.expand("%:p")
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

---Shorten a path to n characters and add ellipsis at the beginning/end
---@param path string The path to shorten
---@param n? number The length to shorten the path to. (default 20)
---@param side? string The side to shorten from. (default 'end')
function M.shorten_path(path, n, side)
	if n == nil or n < 0 then
		n = 20
	end

	side = M.trim(side or "")
	if side == nil or side == "" then
		side = "end"
	end

	if #path <= n then
		return path
	end

	local ellipsis = "..."
	if side == "end" then
		return ellipsis .. path:sub(#path - n + #ellipsis + 1)
	else
		return path:sub(1, n - #ellipsis) .. ellipsis
	end
end

--- Returns the directory path of a given file path
--- @param path string The file path
--- @return string The directory path
function M.dirname(path)
	if path == nil or path == "" then
		return ""
	end

	local path_sep = package.config:sub(1, 1)
	local dir = path:match("^(.*" .. path_sep .. ")")
	return dir or ""
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

---Concatenate two tables without mutating the original
---@param t1 table Original table
---@param t2 table Table to concatenate
---@return table result Concatenated table
function M.concat_tables(t1, t2)
	local cloned = M.deep_clone(t1)
	return vim.list_extend(cloned, t2)
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
	local job_id = vim.fn.jobstart({ "cp", path, new_path }, {
		on_stderr = function(_, data)
			if data[1] ~= "" then
				print("Error cloning file")
				print(vim.inspect(data))
			end
		end,
	})

	vim.fn.jobwait({ job_id })
	return new_path
end

---Deep clone a Lua table
---@param t table
---@return table
function M.deep_clone(t)
	return vim.deepcopy(t)
end

---Check if string includes substring
---@param str string
---@param substr string
---@return boolean
function M.includes(str, substr)
	return str:match(substr) ~= nil
end

---Checks if string is an integer
---@param str string
---@return boolean
function M.is_integer(str)
	return string.match(str, "^[1-9]%d*$") ~= nil
end

---Converts a screen percentage to a width in columns
---@param percentage number The percentage of the screen horizontally
function M.percentage_as_width(percentage)
	return math.floor(vim.o.columns * (percentage / 100))
end

---Converts a screen percentage to a height in lines
---@param percentage number The percentage of the screen vertically
function M.percentage_as_height(percentage)
	return math.floor(vim.o.lines * (percentage / 100))
end

---Checks if a file or directory exists at path
---@param path string The path to check
---@return boolean True if the file or directory exists
function M.file_exists(path)
	local stat = vim.uv.fs_stat(path)
	return stat and (stat.type == "file" or stat.type == "directory") or false
end

---Check if a file or directory exists in the current directory or any parent directory.
---
---This will start from the open buffer's directory and search upwards.
---@param filename string
---@param stop_dir? string The directory to stop searching at (defaults to '.git')
---@return string|nil The path to the file or nil if not found
function M.find_up(filename, stop_dir)
	stop_dir = M.trim(stop_dir or "")
	if not stop_dir or stop_dir == "" then
		stop_dir = ".git"
	end

	local uv = vim.uv or vim.loop
	local cwd = vim.fn.expand("%:p:h")
	local path_sep = package.config:sub(1, 1)

	-- Join path segments using the system's path separator
	local function path_join(...)
		return table.concat({ ... }, path_sep)
	end

	-- Recursively search upwards for the file or directory
	local function search_upwards(dir)
		if vim.fs.basename(dir) == stop_dir then
			return dir
		end

		local file_path = path_join(dir, filename)
		if M.file_exists(file_path) then
			return file_path
		end

		if dir == vim.fn.expand("$HOME") then
			return nil
		end

		if M.includes(dir, stop_dir) then
			return nil
		end

		local parent_dir = uv.fs_realpath(path_join(dir, ".."))
		if parent_dir and parent_dir ~= dir then
			return search_upwards(parent_dir)
		end
	end

	return search_upwards(cwd)
end

return M
