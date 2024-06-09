local api = require("utils.api")

vim.opt_local.wrap = true -- Wrap lines
vim.opt_local.linebreak = true -- Wrap at whole words, not letters
vim.opt_local.breakindent = true -- Match indentation when wrapping line
vim.opt_local.conceallevel = 2 -- Hide markdown formatting

api.nmap("j", "gj", "Move down 1 wrapped line", { buffer = true })
api.nmap("k", "gk", "Move up 1 wrapped line", { buffer = true })
