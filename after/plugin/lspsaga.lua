local utils = require("utils.helpers")
if not utils.exists("lspsaga") then
	return
end

local api = require("utils.api")

api.nmap("gp", "<CMD>Lspsaga peek_definition<CR>", "Peek definition in floating window")
api.nmap("go", "<CMD>Lspsaga outline<CR>", "Open buffer symbol outline in a panel")

require("lspsaga").setup({
	ui = {
		-- Border type can be single, double, rounded, solid, shadow.
		border = "rounded",
		expand = "",
		collapse = "",
	},
	lightbulb = {
		enable = false,
	},
	symbol_in_winbar = {
		enable = false,
	},
	outline = {
		keys = {
			expand_or_jump = "<CR>",
			quit = "q",
		},
	},
})