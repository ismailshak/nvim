local api = require("utils.api")

vim.api.nvim_create_user_command("ToggleBackground", api.toggle_bg, {})
