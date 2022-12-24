local helpers = require("utils.helpers")
if not helpers.exists("catppuccin") then
	return
end

require("catppuccin").setup({
	flavour = "mocha", -- latte, frappe, macchiato, mocha
	background = { -- :h background
		light = "latte",
		dark = "mocha",
	},
	no_italic = false, -- Force no italic
	no_bold = false, -- Force no bold
})
