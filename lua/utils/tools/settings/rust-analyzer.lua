local M = {}

M.settings = {
	["rust-analyzer"] = {
		procMacro = { enable = true },
		cargo = { allFeatures = true },
		checkOnSave = {
			command = "clippy",
			extraArgs = { "--no-deps" },
		},
	},
}

return M
