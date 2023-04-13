local utils = require("utils.helpers")

vim.api.nvim_create_user_command("ToggleBackground", utils.toggle_bg, {})
