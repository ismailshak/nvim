-- General Theme Options
require("custom.colors.nord")
require("custom.colors.tokyonight")
require("custom.colors.iceberg")

local M = {}
M.theme = "iceberg"

-- Set theme
vim.cmd("colorscheme " .. M.theme)

return M
