-- General Theme Options
require("custom.colors.nord")
require("custom.colors.tokyonight")
require("custom.colors.iceberg")
require("custom.colors.rose-pine")

local M = {}
M.theme = "iceberg"

vim.opt.background = "dark"

-- Set theme
vim.cmd("colorscheme " .. M.theme)

return M
