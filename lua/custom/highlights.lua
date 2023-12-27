local M = {}

local api = require("utils.api")

function M.set_custom_highlights()
	-- nvim-dashboard highlights
	api.hi("DashboardIcon", { fg = "#85A4F2", bg = "none" })
	api.hi("DashboardShortCut", { fg = "#85A4F2", bg = "none" })
	api.hi("DashboardFooter", { fg = "#7C7F96", bg = "none" })

	-- nvim-tree highlights
	api.hi("NvimTreeSpecialFile", { bold = true })
end

return M
