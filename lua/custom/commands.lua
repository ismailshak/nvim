local api = require("utils.api")
local highlight = require("custom.highlights")

-- USER COMMANDS --

vim.api.nvim_create_user_command("ToggleBackground", api.toggle_bg, {})

-- AUTOCOMMANDS --

-- Persist colorscheme change to local settings
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		api.save_colorscheme()
		highlight.set_custom_highlights()
	end,
})
