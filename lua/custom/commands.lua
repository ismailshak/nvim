local api = require("utils.api")

-- USER COMMANDS --

vim.api.nvim_create_user_command("ToggleBackground", api.toggle_bg, {})

-- AUTOCOMMANDS --

-- Persist colorscheme change to local settings
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		api.save_colorscheme()
	end,
})
