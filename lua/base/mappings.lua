local utils = require("utils.keybindings")

-- set the leader to space
vim.g.mapleader = " "

-- ctrl+h/j/k/l navigates between split panes
utils.keymap("n", "<c-h>", "<c-w>h")
utils.keymap("n", "<c-j>", "<c-w>j")
utils.keymap("n", "<c-k>", "<c-w>k")
utils.keymap("n", "<c-l>", "<c-w>l")

-- close buffer
utils.keymap("n", "<leader>w", "<cmd>bd<cr>")

-- close tab
utils.keymap("n", "<leader>q", "<cmd>tabclose<cr>")

-- don't yank on delete
utils.keymap("n", "d", '"_d')
utils.keymap("v", "d", '"_d')

-- close all buffers except current one
utils.keymap("n", "<leader>e", ":%bd|e#<CR>"

-- don't yank on cut
-- utils.keymap("n", "x", '"_x')
-- utils.keymap("v", "x", '"_x')

-- move current cursor line up or down
utils.keymap("n", "<A-k>", "<cmd>m .-2<cr>==")
utils.keymap("n", "<A-j>", "<cmd>m +1<cr>==")
utils.keymap("i", "<A-k>", "<Esc><cmd>m .-2<cr>==i")
utils.keymap("i", "<A-j>", "<Esc><cmd>m .+1<cr>==i")
utils.keymap("v", "<A-k>", ":m '<-2<cr>gv=gv")
utils.keymap("v", "<A-j>", ":m '>+1<cr>gv=gv")

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
