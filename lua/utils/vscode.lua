local utils = require("utils.helpers")

---Module to interface with project-specific VSCode settings
local M = {}

function M.settings_path()
	return vim.fs.joinpath(utils.cwd(), ".vscode", "settings.json")
end

---Check if VSCode settings are present in the cwd
function M.settings_exist()
	return vim.fn.filereadable(M.settings_path()) == 1
end

function M.parse_settings()
	if not M.settings_exist() then
		return nil
	end

	local file = io.open(M.settings_path(), "r")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()

	if not content or content == "" then
		return nil
	end

	local settings = vim.json.decode(content, { object = true, array = true })
	return settings
end

---Find a setting in the VSCode settings.json file. Returns nil if the setting is not found.
---@param setting string
---@return any
function M.find_setting(setting)
	if not M.settings_exist() then
		return nil
	end

	local settings = M.parse_settings()
	if not settings then
		return nil
	end

	return settings[setting]
end

return M
