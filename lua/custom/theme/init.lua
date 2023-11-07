local settings = require("custom.settings")

-- General Theme Options (for colorschemes without a lua "setup" interface)
require("custom.theme.nord")
require("custom.theme.substrata")
require("custom.theme.iceberg")

vim.opt.background = settings.get().background
vim.cmd("colorscheme " .. settings.get().theme)
