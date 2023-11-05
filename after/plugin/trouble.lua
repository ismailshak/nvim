local helpers = require("utils.helpers")
local api = require("utils.api")

if not helpers.exists("trouble") then
	return
end

local trouble = require("trouble")

api.nmap("<leader>tt", function()
	trouble.toggle()
end, "Open default Trouble mode")
api.nmap("<leader>tw", function()
	trouble.toggle("workspace_diagnostics")
end, "Open workspace diagnostics in Trouble")
api.nmap("<leader>td", function()
	trouble.toggle("document_diagnostics")
end, "Open document diagnostics in Trouble")
api.nmap("<leader>tq", function()
	trouble.toggle("quickfix")
end, "Open quickfix in Trouble")
api.nmap("<leader>tl", function()
	trouble.toggle("loclist")
end, "Open loclist in Trouble")
api.nmap("tr", function()
	trouble.toggle("lsp_references")
end, "Open LSP references in Trouble")
