local api = require("utils.api")

return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
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

		trouble.setup({
			severity = nil, -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
			padding = false, -- add an extra new line on top of the list
			action_keys = { -- key mappings for actions in the trouble list
				-- map to {} to remove a mapping, for example:
				-- close = {},
			},
			indent_lines = false, -- adds an indent guide below the fold icons
			use_diagnostic_signs = true, -- enabling this uses the signs defined in the lsp client
		})
	end,
}
