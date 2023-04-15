local helpers = require("custom.settings.helpers")

local M = {}

---Replace local settings with provided state
---@param settings Settings
M.update = function(settings)
	local local_path = helpers.assert_local()
	if local_path == nil then
		return settings
	end

	helpers.save(settings)
	return settings
end

---Get the current state of settings
---@return Settings
M.get = function()
	local local_path = helpers.assert_local()
	local default = require("custom.settings.defaults")
	if local_path == nil then
		return default
	end

	local _local = helpers.load()
	if _local == nil then
		return default
	end

	local settings = helpers.merge_settings(default, _local)
	return settings
end

return M
