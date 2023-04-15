local utils = require("utils.helpers")
if not utils.exists("fzf-lua") then
	return
end

utils.nmap("<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", "Open file finder [fzf-lua]")
utils.nmap("<leader>fo", "<cmd>lua require('fzf-lua').oldfiles()<CR>", "Open old files history [fzf-lua]")

local ignore_list = { ".git", "node_modules", "dist", ".next", "target", "build", "out" }

local gen_ignore_list = function()
	local args = ""
	for _, dir in ipairs(ignore_list) do
		args = args .. " --exclude " .. dir
	end

	return args
end

require("fzf-lua").setup({
	"telescope",
	files = {
		prompt = " ",
		git_icons = true,
		file_icons = true,
		color_icons = true,
		fd_opts = "--no-ignore --color=never --type f --hidden --follow" .. gen_ignore_list(),
	},
})
