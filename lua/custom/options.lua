local api = require("utils.api")
local settings = require("custom.settings")

local opt = vim.opt

-- enter :help <option> for more info

-- Colorscheme
vim.opt.background = api.get_system_background()
vim.cmd("colorscheme " .. settings.get().theme)

-- UI
opt.title = true -- set window title
opt.number = true -- line numbers
opt.numberwidth = 2 -- reduces column width (default 4)
opt.fillchars = { eob = " " } -- remove tildas from empty lines
opt.ruler = false -- the cursor position [column,row] in the bottom rowi
opt.cul = true -- cursor line
opt.termguicolors = true
opt.cmdheight = 0 -- removes the space at the bottom for commands
opt.laststatus = 3 -- turns the statusline into a global status line (not 1 per buffer/split)
opt.wrap = false -- disable line wrap
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99 -- Don't close any folds on load
opt.foldenable = false

-- Interactions
opt.mouse = "a" -- enable mouse for all modes
opt.clipboard = "unnamedplus" -- use system clipboard for all operations
opt.timeoutlen = 400 -- time to wait for mapping input to complete (ms)
--opt.updatetime = 250 -- interval for writing swap file to disk (ms)
opt.splitright = true
opt.splitbelow = true
--opt.mapleader = " ", -- the leader in keybinds (space bar)
-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")
opt.confirm = true -- confirm before closing unsaved buffers

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

-- disables the line number column from bouncing whenever
-- the LSP adds an icon to the column - god bless
vim.wo.signcolumn = "yes"

-- Set the diff fill characters to '/', default is '-'
vim.cmd("set fillchars+=diff:╱")
