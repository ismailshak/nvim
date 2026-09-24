local api = require("utils.api")

api.nmap("q", "<cmd>close!<CR>", "Close the float [nvim-dap]", { buf = 0 })
