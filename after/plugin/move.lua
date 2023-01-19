local helpers = require("utils.helpers")
if not helpers.exists("mini.move") then
	return
end

require("mini.move").setup({
	-- Module mappings. Use `''` (empty string) to disable one.
	mappings = {
		-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
		left = "<C-h>",
		right = "<C-l>",
		down = "<C-j>",
		up = "<C-k>",

		-- Move current line in Normal mode
		line_left = "<C-h>",
		line_right = "<C-l>",
		line_down = "<C-j>",
		line_up = "<C-k>",
	},
})
