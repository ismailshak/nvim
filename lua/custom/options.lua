local settings = require("custom.settings")
local api = require("utils.api")
local icons = require("utils.icons")

local opt = vim.opt

-- Colorscheme
opt.background = api.get_system_background()
vim.cmd("silent colorscheme " .. settings.get().theme)

-- UI
opt.title = true -- set window title
opt.number = true -- line numbers
opt.numberwidth = 2 -- reduces column width (default 4)
opt.fillchars = { eob = " ", diff = "╱" } -- remove tildas from empty lines & replace diff with a better character
opt.ruler = false -- the cursor position [column,row] in the bottom rowi
opt.cul = true -- cursor line
opt.termguicolors = true
opt.cmdheight = 0 -- removes the space at the bottom for commands
opt.laststatus = 3 -- turns the statusline into a global status line (not 1 per buffer/split)
opt.wrap = false -- disable line wrap
opt.foldlevel = 99 -- Keep all folds open
opt.foldlevelstart = 99 -- Don't close any folds on load
opt.foldenable = true
opt.signcolumn = "yes" -- always display so icons don't move the text
opt.winfixwidth = true -- don't resize windows when splitting
opt.winborder = "rounded"
opt.diffopt = {
	"internal",
	"filler",
	"closeoff",
	"context:12",
	"algorithm:histogram",
	"linematch:60",
	"indent-heuristic",
}

-- Interactions
opt.mouse = "a" -- enable mouse for all modes
opt.clipboard = "unnamedplus" -- use system clipboard for all operations
opt.timeoutlen = 400 -- time to wait for mapping input to complete (ms)
opt.splitright = true
opt.splitbelow = true
-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")
opt.confirm = true -- confirm before closing unsaved buffers
opt.scrolloff = 5 -- minimum number of lines to keep above and below the cursor

-- Indentation
opt.expandtab = true -- replace tab with spaces
opt.tabstop = 2 -- number of spaces inserted for a tab
opt.softtabstop = 2
opt.shiftwidth = 2

-- Searching
opt.ignorecase = true -- ignored case when matching
opt.smartcase = true -- ignore case until a capital letter is used?

-- Persist undo
opt.undofile = true

-- Session options
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Abbreviations
api.cabbr("W", "w")
api.cabbr("wf", "w")
api.cabbr("Q", "q")
api.cabbr("Wq", "wq")

-- Grep
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep --smart-case --hidden --follow"

-- Filetypes
vim.filetype.add({
	pattern = {
		-- Map `.env.*` to `conf` so that shell-specific LSPs don't start (default is `.env ft=sh`)
		-- and extend it any sub-env files so we get highlighting (e.g. `.env.local`)
		[".env.*"] = "conf",
	},
})

-- Diagnostics
local signs = {
	{ name = "DiagnosticSignError", text = icons.diagnostics.error },
	{ name = "DiagnosticSignWarn", text = icons.diagnostics.warn },
	{ name = "DiagnosticSignInfo", text = icons.diagnostics.info },
	{ name = "DiagnosticSignHint", text = icons.diagnostics.hint },
}

for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config({
	virtual_text = {
		severity = vim.diagnostic.severity.ERROR,
	},
	-- show signs
	signs = {
		active = signs,
	},
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		source = "if_many",
		header = "",
		prefix = "",
	},
})
