local helpers = require("utils.helpers")
if not helpers.exists("indent_blankline") then
	return
end

require("indent_blankline").setup({
	filetype_exclude = { "dashboard" },
	show_current_context = false,
	show_current_context_start = false,
})
