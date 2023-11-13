local api = require("utils.api")
local settings = require("custom.settings")

-- General Theme Options (for colorschemes without a lua "setup" interface)
require("custom.theme.nord")
require("custom.theme.substrata")
require("custom.theme.iceberg")

vim.opt.background = api.get_system_background()
vim.cmd("colorscheme " .. settings.get().theme)
