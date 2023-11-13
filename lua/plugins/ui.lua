local api = require("utils.api")

return {
	{
		"f-person/auto-dark-mode.nvim",
		event = "VimEnter",
		config = {
			update_interval = 1000,
			set_dark_mode = function()
				api.set_bg("dark")
			end,
			set_light_mode = function()
				api.set_bg("light")
			end,
		},
	},
}
