local M = {}

M.languages = {
	"c",
	"cpp",
	"rust",
}

function M.adapters()
	require("dap").adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = "codelldb",
			args = { "--port", "${port}" },
		},
	}
end

function M.configurations()
	local dap = require("dap")

	for _, lang in ipairs(M.languages) do
		dap.configurations[lang] = {
			{
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}
	end
end

function M.setup()
	M.adapters()
	M.configurations()
end

return M
