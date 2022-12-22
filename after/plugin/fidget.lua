local helpers = require("utils.helpers")
if not helpers.exists("fidget") then
	return
end

require("fidget").setup({
	text = {
		spinner = "dots",
	},
})
