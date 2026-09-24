local api = require("utils.api")

-- `require("dap")` loads nvim-dap, whose config runs `dap-go.setup()`. Requiring dap-go directly would skip that.
api.nmap("<leader>dt", function()
	require("dap")
	require("dap-go").debug_test()
end, "Debug test under cursor [nvim-dap-go]", { buf = 0 })

api.nmap("<leader>dT", function()
	require("dap")
	require("dap-go").debug_last_test()
end, "Debug last test [nvim-dap-go]", { buf = 0 })
