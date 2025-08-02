local M = {}

M.settings = {
	["rust-analyzer"] = {
		procMacro = { enable = true },
		cargo = { allFeatures = true },
		checkOnSave = true,
	},
}

return M
