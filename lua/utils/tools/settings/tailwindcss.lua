local vscode = require("utils.vscode")

local M = {}

M.config_file = vscode.find_setting("tailwindCSS.experimental.configFile")

M.settings = {
	tailwindCSS = {
		experimental = {
			configFile = M.config_file,
		},
	},
}

return M
