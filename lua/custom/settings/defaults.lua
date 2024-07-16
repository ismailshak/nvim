---@alias background 'dark' | 'light'

---@alias theme
---| 'iceberg'
---| 'oxocarbon'
---| 'nord'
---| 'rose-pine'
---| 'carbonfox'
---| 'nightfox'
---| 'dayfox'
---| 'catppuccin'
---| 'substrata'

---@class DBConnection
---@field public name string: Connection name
---@field public url string: Connection URL
---
---@class Settings
---@field public background background
---@field public theme theme
---@field public disable_format string: Comma-separated list of directories where formatting should be disabled
---@field public db_connections DBConnection[]: List of database connections

---@type Settings
local M = {
	background = "dark",
	theme = "iceberg",
	disable_format = "",
}

return M
