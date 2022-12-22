local M = {}

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

M.trim = function(str)
	return (str:gsub("^%s*(.-)%s*$", "%1"))
end

M.exists = function(plugin)
	local ok, _ = pcall(require, plugin)
	return ok
end

return M
