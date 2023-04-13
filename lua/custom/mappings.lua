local utils = require("utils.keybindings")

-- set the leader to space
vim.g.mapleader = " "

-- Mappings for custom commands
utils.nmap("<A-A>", ":ToggleBackground<CR>", "Toggle between dark & light background")

-- General binds
utils.nmap("<Esc>", ":noh<CR>", "Remove selection highlighting")
utils.nmap("<C-a>", "ggVG", "Select all in buffer")

utils.nmap("<C-h>", "<c-w>h", "Jump 1 split plane to the left")
utils.nmap("<C-l>", "<c-w>l", "Jump 1 split plane to the right")
utils.nmap("<C-j>", "<c-w>j", "Jump 1 split plane below")
utils.nmap("<C-k>", "<c-w>k", "Jump 1 split plane above")

utils.nmap("<leader>w", ":bd<CR>", "Close currently open buffer")
utils.nmap("<leader>e", ":%bd|e#|bd#<CR>|'\"'", "Close all buffers except the currently open")
utils.nmap("<leader>q", ":tabclose<CR>", "Close an open and focused tab")

-- don't yank on delete
utils.nmap("d", '"_d', "Rebinds 'd' to not yank on delete (normal mode)")
utils.vmap("d", '"_d', "Rebinds 'd' to not yank on delete (visual mode)")
-- utils.nmap("x", '"_x', "Rebinds 'x' to not yank on cut in normal mode")
-- utils.vmap("x", '"_x', "Rebinds 'd' to not yank on delete (visual mode)")

utils.nmap("<A-Up>", "yyP", "Duplicate current line above")
utils.nmap("<A-Down>", "yyp", "Duplicate current line below")
utils.vmap("<A-Up>", "yP", "Duplicate multiple lines")
utils.vmap("<A-Down>", "yP", "Duplicate multiple lines")

utils.nmap("<A-H>", ":vertical resize +2<CR>", "Make split pane wider (normal mode)")
utils.nmap("<A-L>", ":vertical resize -2<CR>", "Make split pane thinner (normal mode)")
utils.nmap("<A-J>", ":horizontal resize -2<CR>", "Make split pane shorter (normal mode)")
utils.nmap("<A-K>", ":horizontal resize +2<CR>", "Make split pane longer (normal mode)")
utils.vmap("<A-H>", ":vertical resize -2<CR>", "Make split pane shorter (visual mode)")
utils.vmap("<A-L>", ":vertical resize +2<CR>", "Make split pane longer (visual mode)")
utils.vmap("<A-J>", ":horizontal resize -2<CR>", "Make split pane thinner (visual mode)")
utils.vmap("<A-K>", ":horizontal resize +2<CR>", "Make split pane wider (visual mode)")

utils.vmap("<C-r>", '"hy:%s/<C-r>h//gc<left><left><left>', "Replace all occurrences of selected text")

utils.nmap("<TAB>", ":bnext<CR>", "Cycle to next buffer")
utils.nmap("<S-TAB>", ":bprevious<CR>", "Cycle to previous buffer")

-- CURRENTLY HANDLED BY A PLUGIN
--
-- move current cursor line up or down
--[[ utils.nmap("<A-k>", ":m .-2<CR>==") ]]
--[[ utils.nmap("<A-j>", ":m +1<CR>==") ]]
--[[ utils.imap("<A-k>", "<Esc>:m .-2<CR>==i") ]]
--[[ utils.imap("<A-j>", "<Esc>:m .+1<CR>==i") ]]
--[[ utils.vmap("<A-k>", ":m '<-2<CR>gv=gv") ]]
--[[ utils.vmap("<A-j>", ":m '>+1<CR>gv=gv") ]]

--[[
Move line mapping explanation

The command :m .+1 (which can be abbreviated to :m+) moves the current line to after line number .+1 (current line number + 1).
That is, the current line is moved down one line.

The command :m .-2 (which can be abbreviated to :m-2) moves the current line to after line number .-2 (current line number − 2).
That is, the current line is moved up one line.

After visually selecting some lines, entering :m '>+1 moves the selected lines to after line number '>+1 (one line after the last selected line; '>
is a mark assigned by Vim to identify the selection end). That is, the block of selected lines is moved down one line.

The == re-indents the line to suit its new position. For the visual-mode mappings, gv reselects the last visual block and = re-indents that block.
--]]
