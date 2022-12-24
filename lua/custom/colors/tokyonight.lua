local helpers = require("utils.helpers")
if not helpers.exists("") then
	return
end

require("tokyonight").setup({
	style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
	light_style = "day", -- The theme is used when the background is set to light
	sidebars = { "qf", "help", "terminal", "packer", "NvimTree" }, -- Set a darker background on sidebar-like windows.
	day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
})
