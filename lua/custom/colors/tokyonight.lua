local helpers = require("utils.helpers")
if not helpers.exists("tokyonight") then
	return
end

require("tokyonight").setup({
	style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
	light_style = "day", -- The theme is used when the background is set to light
	sidebars = { "qf", "help", "terminal", "NvimTree" }, -- Set a darker background on sidebar-like windows.
	day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
	styles = {
		-- Style to be applied to different syntax groups
		-- Value is any valid attr-list value for `:help nvim_set_hl`
		comments = { italic = false },
		keywords = { italic = false },
	},
})
