local M = {}

local utils = require("utils.helpers")
local tools = require("utils.tools.spec")

M.servers = utils.concat_tables(tools.default_servers, tools.optional_servers)

---Sets the capabilities shared by every server and enables the servers. Per-server config is in `after/lsp/`.
function M.setup_lsp()
	local capabilities = require("blink.cmp").get_lsp_capabilities({}, false)
	-- What nvim-lsp-file-operations' `default_capabilities()` returns with its default config. Requiring the plugin
	-- here would load nvim-tree on the first file open.
	capabilities.workspace = {
		fileOperations = {
			didCreate = true,
			didDelete = true,
			didRename = true,
			willCreate = true,
			willDelete = true,
			willRename = true,
		},
	}

	vim.lsp.config("*", { capabilities = capabilities })

	M.configure_typescript()

	-- lspconfig loads inside the BufReadPost or BufNewFile event of a buffer, before its filetype is detected. `enable`
	-- runs the FileType event for open buffers. Running it before detection makes `:setfiletype` skip the buffer.
	vim.schedule(function()
		vim.lsp.enable(M.servers)
	end)
end

---Project roots mapped to whether the project's own `tsc` is TypeScript 7 or later
local tsc7 = {} ---@type table<string, boolean>

---@param root string
---@return boolean
local function project_has_tsc7(root)
	if tsc7[root] == nil then
		local bin = vim.fs.joinpath(root, "node_modules/.bin/tsc")
		local out = vim.fn.executable(bin) == 1 and vim.system({ bin, "--version" }, { text = true }):wait() or nil
		local version = out and out.code == 0 and vim.version.parse(out.stdout) or nil
		tsc7[root] = version ~= nil and version.major >= 7
	end
	return tsc7[root]
end

---Attaches `tsc` in projects on TypeScript 7 or later and `vtsls` in every other project. `tsc` is the language server
---built into TypeScript 7. `vtsls` bundles TypeScript 5.9 for projects that have not moved to 7. These are
---`vim.lsp.config()` calls because an `after/lsp/vtsls.lua` that reads `vim.lsp.config.vtsls` would load itself.
function M.configure_typescript()
	-- lspconfig's `tsc` config warns in every project without a `tsc` that supports `--lsp`. To skip that check in
	-- TypeScript 5 and 6 projects, `vtsls`'s `root_dir` finds the root for both configs. The two find it the same way.
	local vtsls_root_dir = vim.lsp.config.vtsls.root_dir
	-- lspconfig's `tsc` `root_dir` saves the binary it finds in a table. `cmd` starts the binary saved in that table.
	-- The `vim.lsp.config()` call below makes nvim run `lsp/tsc.lua` again and create a second table. Setting `cmd`
	-- from this read keeps `root_dir` and `cmd` on the same table.
	local tsc = vim.lsp.config.tsc

	vim.lsp.config("vtsls", {
		root_dir = function(bufnr, on_dir)
			vtsls_root_dir(bufnr, function(root)
				if not project_has_tsc7(root) then
					on_dir(root)
				end
			end)
		end,
	})

	vim.lsp.config("tsc", {
		cmd = tsc.cmd,
		root_dir = function(bufnr, on_dir)
			vtsls_root_dir(bufnr, function(root)
				if project_has_tsc7(root) then
					tsc.root_dir(bufnr, on_dir)
				end
			end)
		end,
	})
end

return M
