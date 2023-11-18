local M = {}

local api = require("utils.api")

M.set_custom_highlights = function()
	-- nvim-dashboard highlights
	api.hi("DashboardHeader", { fg = "#85A4F2", bg = "none" }) -- lua file icon blue
	api.hi("DashboardIcon", { fg = "#85A4F2", bg = "none" })
	api.hi("DashboardShortCut", { fg = "#85A4F2", bg = "none" })
	api.hi("DashboardFooter", { fg = "#7C7F96", bg = "none" })
end

return M
