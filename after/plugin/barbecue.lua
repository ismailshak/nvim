local helpers = require("utils.helpers")
if not helpers.exists("barbecue") then
	return
end

require("barbecue").setup({
	show_dirname = false,
	show_modified = true,
	exclude_filetypes = { "dashboard" },
})
