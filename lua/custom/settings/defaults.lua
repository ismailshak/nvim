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

---@class Settings
---@field public background background
---@field public copilot boolean
---@field public theme theme
---@field public disable_format string[]: List of directories where formatting will not run on save (e.g. {"node_modules", "my_folder/dist"})

---@type Settings
local M = {
	background = "dark",
	copilot = true,
	theme = "iceberg",
	disable_format = {},
}

return M
