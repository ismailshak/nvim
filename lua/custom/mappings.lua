local api = require("utils.api")
local utils = require("utils.helpers")

-- set the leader to space
vim.g.mapleader = " "

-- Mappings for plugin manager
api.nmap("<leader>pm", "<CMD>Lazy<CR>", "Open [p]lugin [m]anager")

-- General binds
api.nmap("<leader>ss", "<CMD>w<CR>", "Save buffer")
api.nmap("<Esc>", "<CMD>noh<CR>", "Remove selection highlighting")
api.nmap("<C-a>", "ggVG", "Select all in buffer")
api.nmap("<leader>r", "<CMD>source %<CR>", "Source current buffer")
api.imap("<C-z>", "<Esc>zza", "Center cursor position in window while in insert mode")

api.nmap("<leader>w", "<CMD>bd<CR>", "Close currently open buffer")
api.nmap("<leader>e", "<CMD>%bd|e#|bd#<CR>|'\"", "Close all buffers except the currently open")
api.nmap("<leader>q", "<CMD>tabclose<CR>", "Close an open and focused tab")

api.nmap("+", "<C-a>", "Increment number under cursor")
api.nmap("-", "<C-x>", "Decrement number under cursor")

api.nmap("<C-d>", "<C-d>zz", "scroll down")
api.nmap("<C-u>", "<C-u>zz", "scroll up")

api.nmap("]q", vim.cmd.cnext, "Next Quickfix Item")
api.nmap("[q", vim.cmd.cprev, "Previous Quickfix Item")

api.nmap("<leader>tw", "<CMD>set wrap!<CR>", "Toggle text wrap")

-- Don't yank on delete / change
api.nmap("d", '"_d', "Rebinds 'd' to not yank on delete (normal mode)")
api.vmap("d", '"_d', "Rebinds 'd' to not yank on delete (visual mode")
api.nmap("c", '"_c', "Rebinds 'c' to not yank on removal (normal mode)")
api.vmap("c", '"_c', "Rebinds 'c' to not yank on removal (visual mode)")

-- LSP
api.nmap("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic errors")
api.nmap("]d", vim.diagnostic.goto_next, "Go to next diagnostic errors")
api.nmap("gl", vim.diagnostic.open_float, "Open diagnostic error window")

api.nmap("<A-Up>", "yyP", "Duplicate current line above")
api.nmap("<A-Down>", "yyp", "Duplicate current line below")
api.vmap("<A-Up>", "yP", "Duplicate multiple lines")
api.vmap("<A-Down>", "yP", "Duplicate multiple lines")

-- Splits
api.nmap("<C-h>", "<c-w>h", "Jump 1 split plane to the left")
api.nmap("<C-l>", "<c-w>l", "Jump 1 split plane to the right")
api.nmap("<C-j>", "<c-w>j", "Jump 1 split plane below")
api.nmap("<C-k>", "<c-w>k", "Jump 1 split plane above")

api.nmap("<A-H>", "<CMD>vertical resize +2<CR>", "Make split pane wider (normal mode)")
api.nmap("<A-L>", "<CMD>vertical resize -2<CR>", "Make split pane thinner (normal mode)")
api.nmap("<A-J>", "<CMD>horizontal resize -2<CR>", "Make split pane shorter (normal mode)")
api.nmap("<A-K>", "<CMD>horizontal resize +2<CR>", "Make split pane longer (normal mode)")
api.vmap("<A-H>", "<CMD>vertical resize -2<CR>", "Make split pane shorter (visual mode)")
api.vmap("<A-L>", "<CMD>vertical resize +2<CR>", "Make split pane longer (visual mode)")
api.vmap("<A-J>", "<CMD>horizontal resize -2<CR>", "Make split pane thinner (visual mode)")
api.vmap("<A-K>", "<CMD>horizontal resize +2<CR>", "Make split pane wider (visual mode)")

-- Replacing text
api.vmap("<C-f>", '"hy:%s/<C-r>h//g<left><left>', "Replace all occurrences of selected text")
api.nmap("<C-f>", 'viw"hy:%s/<C-r>h//g<left><left>', "Replace all occurrences of word under cursor")

api.tmap("<Esc>", "<C-\\><C-n>", "Escape terminal mode")

------------------------------
-- PLUGIN SPECIFIC MAPPINGS --
------------------------------

local M = {}

function M.lsp(bufnr)
	local function gen_desc(desc)
		return desc .. " (LSP)"
	end

	local opts = { buffer = bufnr }
	api.nmap("grn", vim.lsp.buf.rename, gen_desc("Rename"), opts)
	api.nmap("gra", vim.lsp.buf.code_action, gen_desc("Code Action"), opts)
	api.vmap("gra", vim.lsp.buf.code_action, gen_desc("Selected range Code Action"), opts)
	api.nmap("grr", "<CMD>FzfLua lsp_references<CR>", gen_desc("Goto references"), opts)

	api.nmap("gd", vim.lsp.buf.definition, gen_desc("Goto Definition"), opts)
	api.nmap("gI", vim.lsp.buf.implementation, gen_desc("Goto Implementation"), opts)
	api.nmap("<leader>D", vim.lsp.buf.type_definition, gen_desc("Type Definition"), opts)
	api.nmap("<leader>fs", "<CMD>FzfLua lsp_document_symbols<CMD>", gen_desc("Document symbols"), opts)
	api.nmap("<leader>fS", "CMD>FzfLua lsp_workspace_symbols<CR>", gen_desc("Workspace symbols"), opts)

	-- See `:help K` for why tis keymap
	api.nmap("K", vim.lsp.buf.hover, gen_desc("Hover Documentation"), opts)
	api.nmap("<C-i>", vim.lsp.buf.signature_help, gen_desc("Signature Documentation"), opts)

	-- Lesser used LSP functionality
	api.nmap("gD", vim.lsp.buf.declaration, gen_desc("[G]oto [D]eclaration"), opts)
	api.nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, gen_desc("[W]orkspace [A]dd Folder"), opts)
	api.nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, gen_desc("[W]orkspace [R]emove Folder"), opts)
	api.nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, gen_desc("Workspace list folders"), opts)
end

function M.leap()
	-- Prevents leap from overriding the default x mapping
	api.vmap("x", "x", "Default x mapping")
end

function M.lspsaga()
	api.nmap("gp", "<CMD>Lspsaga peek_definition<CR>", "Peek definition in floating window")
	api.nmap("go", "<CMD>Lspsaga outline<CR>", "Open buffer symbol outline in a panel")
end

function M.undotree()
	api.nmap("<leader>uu", "<CMD>UndotreeToggle<CR>", "Toggle undo tree")
end

function M.gitsigns(bufnr)
	local gs = require("gitsigns")
	local default_opts = { buffer = bufnr }

	-- Navigation
	api.nmap("]c", function()
		if vim.wo.diff then
			return "]c"
		end
		vim.schedule(function()
			gs.next_hunk()
		end)
		return "<Ignore>"
	end, "Navigate to next hunk [gitsigns]", { expr = true, buffer = bufnr })

	api.nmap("[c", function()
		if vim.wo.diff then
			return "[c"
		end
		vim.schedule(function()
			gs.prev_hunk()
		end)
		return "<Ignore>"
	end, "Navigate to previous hunk [gitsigns]", { expr = true, buffer = bufnr })

	-- Actions
	api.map(
		{ "n", "v" },
		"<leader>hs",
		"<CMD>Gitsigns stage_hunk<CR>",
		"Stage hunk under cursor [gitsigns]",
		default_opts
	)
	api.map(
		{ "n", "v" },
		"<leader>hr",
		"<CMD>Gitsigns reset_hunk<CR>",
		"Reset hunk under cursor [gitsigns]",
		default_opts
	)
	api.nmap("<leader>hS", gs.stage_buffer, "Stage the current buffer [gitsigns]", default_opts)
	api.nmap("<leader>hu", gs.undo_stage_hunk, "Undo staging of hunk [gitsigns]", default_opts)
	api.nmap("<leader>hR", gs.reset_buffer, "Reset the current buffer [gitsigns]", default_opts)
	api.nmap("<leader>hP", gs.preview_hunk, "Previw hunk under cursor [gitsigns]", default_opts)
	api.nmap("<leader>hp", gs.preview_hunk_inline, "Inline previw hunk under cursor [gitsigns]", default_opts)
	api.nmap("<leader>hb", function()
		gs.blame_line({ full = true })
	end, "Show blame for line under cursor [gitsigns]", default_opts)
	api.nmap("<leader>tb", gs.toggle_current_line_blame, "Toggle blame for current line [gitsigns]", default_opts)
	api.nmap("<leader>hd", gs.diffthis, "Diff this [gitsigns]", default_opts)
	api.nmap("<leader>hD", function()
		gs.diffthis("~")
	end, "Diff this ~ [gitsigns]", default_opts)
	api.nmap("<leader>hr", gs.toggle_deleted, "Toggle deleted [gitsigns]", default_opts)

	-- Text object
	api.map(
		{ "o", "x" },
		"ih",
		"<CMD><C-U>Gitsigns select_hunk<CR>",
		"Motion for inside git hunk [gitsigns]",
		default_opts
	)
end

function M.cellular_automation()
	api.nmap("<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", "Make it rain")
end

function M.fzf()
	api.nmap("<leader>ff", "<CMD>FzfLua files<CR>", "Open file finder [fzf-lua]")
	api.nmap("<leader>fo", "<cmd>FzfLua oldfiles<CR>", "Open old files history [fzf-lua]")
	api.nmap("<leader>rr", "<CMD>FzfLua resume<CR>", "Open last picker [fzf-lua]")
	api.nmap("<leader>fd", "<CMD>FzfLua diagnostics_workspace<CR>", "Find project diagnostics [fzf-lua]")
	api.nmap("<leader>fg", "<CMD>FzfLua live_grep <CR>", "Find by grep pattern [fzf-lua]")
	api.nmap("<leader>bb", "<CMD>FzfLua buffers <CR>", "Buffer list [fzf-lua]")
	api.nmap("<leader>fh", "<CMD>FzfLua helptags <CR>", "Find help tags [fzf-lua]")
	api.nmap("<leader>?", "<CMD>FzfLua keymaps<CR>", "List all active mappings [fzf-lua]")
	api.nmap("<leader>gb", "<CMD>FzfLua git_branches <CR>", "Show git branches [fzf-lua]")
	api.nmap("<leader>gc", "<CMD>FzfLua git_commits <CR>", "Show git commits [fzf-lua]")
	api.nmap("<leader>gt", "<CMD>FzfLua git_status <CR>", "Run git status [fzf-lua]")
	api.nmap("<leader>sc", "<CMD>FzfLua spell_suggest <CR>", "Suggest spelling [fzf-lua]")
	api.nmap("<leader>fc", "<CMD>FzfLua grep_curbuf<CR>", "Fuzzy find in buffer [fzf-lua]")
	api.nmap("<leader>th", "<CMD>FzfLua colorscheme<CR>", "Colorscheme picker [fzf-lua]")
end

function M.ufo()
	-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
	api.nmap("zR", require("ufo").openAllFolds, "Open all fold [ufo]")
	api.nmap("zM", require("ufo").closeAllFolds, "Close all fold [ufo]")
	api.nmap("zK", function()
		local winid = require("ufo").peekFoldedLinesUnderCursor()
		if not winid then
			vim.lsp.buf.hover()
		end
	end, "Peek fold under cursor [ufo]")
end

function M.toggleterm()
	api.nmap("<c-\\>", "<CMD>ToggleTerm direction=float<CR>", "Toggle terminal float [ToggleTerm]")
	api.tmap("<c-\\>", function()
		require("toggleterm").toggle()
	end, "Close terminal float [ToggleTerm]")
end

function M.diffview()
	api.nmap("<leader>dv", "<cmd>DiffviewOpen<cr>", "Open diff view")
	api.nmap("<leader>df", "<cmd>DiffviewFileHistory %<cr>", "Open file history")
end

function M.nvim_tree()
	api.nmap("<c-n>", "<CMD>NvimTreeFindFileToggle <CR>", "Toggle file tree")
end

function M.copilot()
	api.nmap("<leader>ce", "<CMD>Copilot enable<CR>", "Enable copilot autocomplete [copilot]")
	api.nmap("<leader>cd", "<CMD>Copilot disable<CR>", "Disable copilot autocomplete [copilot]")
end

function M.copilot_chat()
	local chat = require("CopilotChat")

	api.map(
		{ "n", "x" },
		"<leader>cv",
		"<CMD>CopilotChatToggle<CR>",
		"Toggle copilot chat in a vertical split [CopilotChat]"
	)

	api.map({ "n", "x" }, "<leader>cc", function()
		chat.toggle({
			window = {
				layout = "float",
				title = "",
				width = 0.8,
				height = 0.8,
				border = "rounded",
			},
		})
	end, "Toggle copilot chat in a floating window [CopilotChat]")

	api.map({ "n", "x" }, "<leader>ch", function()
		chat.toggle({
			window = {
				layout = "horizontal",
			},
		})
	end, "Toggle copilot chat in a horizontal split [CopilotChat]")
end

function M.dap_ui()
	api.nmap("<leader>du", require("dapui").toggle, "Toggle DAP UI [nvim-dap-ui]")
end

function M.dap_go()
	api.nmap("<leader>dt", require("dap-go").debug_test, "Debug test under cursor [nvim-dap-go]")
	api.nmap("<leader>dT", require("dap-go").debug_last_test, "Debug last test [nvim-dap-go]")
end

function M.dap()
	api.nmap("<leader>dd", require("dap").continue, "Debugger continue [nvim-dap]")
	api.nmap("<leader>dx", require("dap").disconnect, "Debugger disconnect [nvim-dap]")
	api.nmap("<leader>db", require("dap").toggle_breakpoint, "Toggle breakpoint [nvim-dap]")
	api.nmap("<leader>dB", require("dap").clear_breakpoints, "Clear all breakpoints [nvim-dap]")
	api.nmap("<leader>dr", require("dap").restart, "Debugger restart [nvim-dap]")
	api.nmap("<leader>ds", require("dap").terminate, "Debugger terminate [nvim-dap]")
	api.nmap("<leader>do", require("dap").step_over, "Step over [nvim-dap]")
	api.nmap("<leader>dO", require("dap").step_out, "Step out [nvim-dap]")
	api.nmap("<leader>di", require("dap").step_into, "Step into [nvim-dap]")
	api.nmap("<leader>dk", require("dap.ui.widgets").hover, "View value under cursor [nvim-dap]")

	api.nmap("<leader>de", function()
		vim.ui.input({
			prompt = "Expression: ",
		}, function(expression)
			if not expression or expression == "" then
				return
			end

			require("dap").toggle_breakpoint(expression, nil, nil)
		end)
	end, "Toggle conditional breakpoint [nvim-dap]")

	api.nmap("<leader>dc", function()
		vim.ui.input({
			prompt = "Hit Count: ",
		}, function(count)
			if not count or count == "" then
				return
			end

			if not utils.is_integer(count) then
				vim.notify("Hit count must be a valid integer", vim.log.levels.ERROR)
				return
			end

			require("dap").toggle_breakpoint(nil, count, nil)
		end)
	end, "Toggle hit count breakpoint [nvim-dap]")

	api.nmap("<leader>dl", function()
		vim.ui.input({
			prompt = "Logpoint message: ",
			-- Highlight interpolated variables
			highlight = function(input)
				local s, e = string.find(input, "{.-}")
				if s then
					return { { s - 1, e, "Comment" } }
				end
				return {}
			end,
		}, function(message)
			if not message or message == "" then
				return
			end

			require("dap").toggle_breakpoint(nil, nil, message)
		end)
	end, "Toggle logpoint [nvim-dap]")

	if vim.bo.filetype == "go" then
		M.dap_go()
	end

	-- These should be in commands.lua, but since I'm just adding mappings I'm gonna look the other way
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "dap-float",
		command = "nnoremap <buffer><silent> q <cmd>close!<CR>",
	})
end

function M.dadbod()
	api.nmap("<leader>bd", "<CMD>DBUIToggle<CR>", "Toggle database client [dadbod]")
end

return M
