local helpers = require("utils.helpers")
if not helpers.exists("rose-pine") then
	return
end

require("rose-pine").setup({
	variant = "main",
	disable_italics = true,
	highlight_groups = {
		["@constant.builtin"] = { fg = "pine" },
		["@function.builtin"] = { fg = "pine" },
		["@variable.builtin"] = { fg = "pine" },
	},
})
