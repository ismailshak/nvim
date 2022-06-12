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
utils.keymap("n", "<leader>t", "<cmd>tabclose<cr>")
