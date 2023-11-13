local api = require("utils.api")

-- set the leader to space
vim.g.mapleader = " "

-- Mappings for plugin manager
api.nmap("<leader>pm", ":Lazy<CR>", "Open [p]lugin [m]anager")

-- General binds
api.nmap("<leader>ss", ":w<CR>", "Save buffer")
api.nmap("<Esc>", ":noh<CR>", "Remove selection highlighting")
api.nmap("<C-a>", "ggVG", "Select all in buffer")
api.nmap("<leader>r", ":source %<CR>", "Source current buffer")
api.imap("<C-z>", "<Esc>zza", "Center cursor position in window while in insert mode")

api.nmap("<C-h>", "<c-w>h", "Jump 1 split plane to the left")
api.nmap("<C-l>", "<c-w>l", "Jump 1 split plane to the right")
api.nmap("<C-j>", "<c-w>j", "Jump 1 split plane below")
api.nmap("<C-k>", "<c-w>k", "Jump 1 split plane above")

api.nmap("<leader>w", ":bd<CR>", "Close currently open buffer")
api.nmap("<leader>e", ":%bd|e#|bd#<CR>|'\"'", "Close all buffers except the currently open")
api.nmap("<leader>q", ":tabclose<CR>", "Close an open and focused tab")

-- don't yank on delete / change
api.nmap("d", '"_d', "Rebinds 'd' to not yank on delete (normal mode)")
api.vmap("d", '"_d', "Rebinds 'd' to not yank on delete (visual mode")
api.nmap("c", '"_c', "Rebinds 'c' to not yank on removal (normal mode)")
api.vmap("c", '"_c', "Rebinds 'c' to not yank on removal (visual mode)")

api.nmap("<A-Up>", "yyP", "Duplicate current line above")
api.nmap("<A-Down>", "yyp", "Duplicate current line below")
api.vmap("<A-Up>", "yP", "Duplicate multiple lines")
api.vmap("<A-Down>", "yP", "Duplicate multiple lines")

api.nmap("<A-H>", ":vertical resize +2<CR>", "Make split pane wider (normal mode)")
api.nmap("<A-L>", ":vertical resize -2<CR>", "Make split pane thinner (normal mode)")
api.nmap("<A-J>", ":horizontal resize -2<CR>", "Make split pane shorter (normal mode)")
api.nmap("<A-K>", ":horizontal resize +2<CR>", "Make split pane longer (normal mode)")
api.vmap("<A-H>", ":vertical resize -2<CR>", "Make split pane shorter (visual mode)")
api.vmap("<A-L>", ":vertical resize +2<CR>", "Make split pane longer (visual mode)")
api.vmap("<A-J>", ":horizontal resize -2<CR>", "Make split pane thinner (visual mode)")
api.vmap("<A-K>", ":horizontal resize +2<CR>", "Make split pane wider (visual mode)")

api.vmap("<C-r>", '"hy:%s/<C-r>h//gc<left><left><left>', "Replace all occurrences of selected text")

api.nmap("<S-TAB>", ":bprevious<CR>", "Cycle to previous buffer")

-- CURRENTLY HANDLED BY A PLUGIN
--
-- move current cursor line up or down
--[[ api.nmap("<A-k>", ":m .-2<CR>==") ]]
--[[ api.nmap("<A-j>", ":m +1<CR>==") ]]
--[[ api.imap("<A-k>", "<Esc>:m .-2<CR>==i") ]]
--[[ api.imap("<A-j>", "<Esc>:m .+1<CR>==i") ]]
--[[ api.vmap("<A-k>", ":m '<-2<CR>gv=gv") ]]
--[[ api.vmap("<A-j>", ":m '>+1<CR>gv=gv") ]]

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
