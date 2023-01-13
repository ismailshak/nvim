local helpers = require("utils.helpers")
if not helpers.exists("Fterm") then
	return
end

local utils = require("utils.keybindings")

utils.nmap("<c-\\>", '<cmd>lua require("Fterm").toggle()<cr>', "toggle terminal")
utils.tmap("<c-\\>", '<c-\\><c-n><cmd>lua require("Fterm").toggle()<cr>', "toggle when open")

require("Fterm").setup({
	---Filetype of the terminal buffer
	---@type string
	ft = "Fterm",

	---Command to run inside the terminal
	---NOTE: if given string[], it will skip the shell and directly executes the command
	---@type fun():(string|string[])|string|string[]
	cmd = os.getenv("SHELL"),

	---Neovim's native window border. See `:h nvim_open_win` for more configuration options.
	border = "single",

	---Close the terminal as soon as shell/command exits.
	---Disabling this will mimic the native terminal behaviour.
	---@type boolean
	auto_close = true,

	---Highlight group for the terminal. See `:h winhl`
	---@type string
	hl = "Normal",

	---Transparency of the floating window. See `:h winblend`
	---@type integer
	blend = 20,

	---Object containing the terminal window dimensions.
	---The value for each field should be between `0` and `1`
	---@type table<string,number>
	dimensions = {
		height = 0.8, -- Height of the terminal window
		width = 0.8, -- Width of the terminal window
		x = 0.5, -- X axis of the terminal window
		y = 0.5, -- Y axis of the terminal window
	},

	---Callback invoked when the terminal exits.
	---See `:h jobstart-options`
	---@type fun()|nil
	on_exit = nil,

	---Callback invoked when the terminal emits stdout data.
	---See `:h jobstart-options`
	---@type fun()|nil
	on_stdout = nil,

	---Callback invoked when the terminal emits stderr data.
	---See `:h jobstart-options`
	---@type fun()|nil
	on_stderr = nil,
})
