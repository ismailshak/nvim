local settings = require("custom.settings")

-- General Theme Options
require("custom.colors.nord")
require("custom.colors.tokyonight")
require("custom.colors.iceberg")
require("custom.colors.rose-pine")

vim.opt.background = settings.get().background
vim.cmd("colorscheme " .. settings.get().theme)
