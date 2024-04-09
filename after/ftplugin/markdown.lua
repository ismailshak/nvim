local api = require("utils.api")

vim.opt_local.wrap = true -- Wrap lines
vim.opt_local.linebreak = true -- Wrap at whole words, not letters
vim.opt_local.breakindent = true -- Match indentation when wrapping line

api.nmap("j", "gj", "Move down 1 wrapped line", { buffer = true })
api.nmap("k", "gk", "Move up 1 wrapped line", { buffer = true })
