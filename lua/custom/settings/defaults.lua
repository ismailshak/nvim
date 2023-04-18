---@class Settings
local M = {
	---@alias background 'dark' | 'light'
	---@type background
	background = "dark",

	---@alias theme
	---| 'iceberg'
	---| 'oxocarbon'
	---| 'nord'
	---| 'rose-pine'
	---| 'carbonfox'
	---| 'nightfox'
	---| 'dayfox'
	---| 'catppuccin'
	--@type theme
	theme = "iceberg",

	---Comma-separated list of directories where formatting should be disabled
	---@type string
	disable_format = "",
}

return M
