local api = require("utils.api")
local utils = require("utils.helpers")

-- set the leader to space
vim.g.mapleader = " "

-- Mappings for plugin manager
api.nmap("<leader>pm", ":Lazy<CR>", "Open [p]lugin [m]anager")

-- General binds
api.nmap("<leader>ss", ":w<CR>", "Save buffer")
api.nmap("<Esc>", ":noh<CR>", "Remove selection highlighting")
api.nmap("<C-a>", "ggVG", "Select all in buffer")
api.nmap("<leader>r", ":source %<CR>", "Source current buffer")
api.imap("<C-z>", "<Esc>zza", "Center cursor position in window while in insert mode")

api.nmap("<leader>w", ":bd<CR>", "Close currently open buffer")
api.nmap("<leader>e", ":%bd|e#|bd#<CR>|'\"'", "Close all buffers except the currently open")
api.nmap("<leader>q", ":tabclose<CR>", "Close an open and focused tab")

api.nmap("+", "<C-a>", "Increment number under cursor")
api.nmap("-", "<C-x>", "Decrement number under cursor")

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

api.nmap("<A-H>", ":vertical resize +2<CR>", "Make split pane wider (normal mode)")
api.nmap("<A-L>", ":vertical resize -2<CR>", "Make split pane thinner (normal mode)")
api.nmap("<A-J>", ":horizontal resize -2<CR>", "Make split pane shorter (normal mode)")
api.nmap("<A-K>", ":horizontal resize +2<CR>", "Make split pane longer (normal mode)")
api.vmap("<A-H>", ":vertical resize -2<CR>", "Make split pane shorter (visual mode)")
api.vmap("<A-L>", ":vertical resize +2<CR>", "Make split pane longer (visual mode)")
api.vmap("<A-J>", ":horizontal resize -2<CR>", "Make split pane thinner (visual mode)")
api.vmap("<A-K>", ":horizontal resize +2<CR>", "Make split pane wider (visual mode)")

-- Replacing text
api.vmap("<C-f>", '"hy:%s/<C-r>h//g<left><left>', "Replace all occurrences of selected text")
api.nmap("<C-f>", 'viw"hy:%s/<C-r>h//g<left><left>', "Replace all occurrences of word under cursor")

api.nmap("<S-TAB>", ":bprevious<CR>", "Cycle to previous buffer")

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
	api.nmap("<leader>rn", vim.lsp.buf.rename, gen_desc("[R]e[n]ame"), opts)
	api.nmap("<leader>ca", vim.lsp.buf.code_action, gen_desc("[C]ode [A]ction"), opts)
	api.vmap("<leader>ca", vim.lsp.buf.code_action, gen_desc("Selected range [C]ode [A]ction"), opts)

	api.nmap("gd", vim.lsp.buf.definition, gen_desc("[G]oto [D]efinition"), opts)
	api.nmap("gr", require("telescope.builtin").lsp_references, gen_desc("[G]oto [R]eferences"), opts)
	api.nmap("gI", vim.lsp.buf.implementation, gen_desc("[G]oto [I]mplementation"), opts)
	api.nmap("<leader>D", vim.lsp.buf.type_definition, gen_desc("Type [D]efinition"), opts)
	api.nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, gen_desc("[D]ocument [S]ymbols"), opts)
	api.nmap(
		"<leader>ws",
		require("telescope.builtin").lsp_dynamic_workspace_symbols,
		gen_desc("[W]orkspace [S]ymbols"),
		opts
	)

	-- See `:help K` for why this keymap
	api.nmap("K", vim.lsp.buf.hover, gen_desc("Hover Documentation"), opts)
	api.nmap("<C-i>", vim.lsp.buf.signature_help, gen_desc("Signature Documentation"), opts)

	-- Lesser used LSP functionality
	api.nmap("gD", vim.lsp.buf.declaration, gen_desc("[G]oto [D]eclaration"), opts)
	api.nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, gen_desc("[W]orkspace [A]dd Folder"), opts)
	api.nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, gen_desc("[W]orkspace [R]emove Folder"), opts)
	api.nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, gen_desc("[W]orkspace [L]ist Folders"), opts)
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
	api.map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage hunk under cursor [gitsigns]", default_opts)
	api.map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset hunk under cursor [gitsigns]", default_opts)
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
	api.nmap("<leader>hd", gs.diffthis, "Diff this [gitsigns]", default_opts)
	api.nmap("<leader>hD", function()
		gs.diffthis("~")
	end, "Diff this ~ [gitsigns]", default_opts)
	api.nmap("<leader>hr", gs.toggle_deleted, "Toggle deleted [gitsigns]", default_opts)

	-- Text object
	api.map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Motion for inside git hunk [gitsigns]", default_opts)
end

function M.cellular_automation()
	api.nmap("<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", "Make it rain")
end

function M.fzf()
	api.nmap("<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", "Open file finder [fzf-lua]")
	api.nmap("<leader>fo", "<cmd>lua require('fzf-lua').oldfiles()<CR>", "Open old files history [fzf-lua]")
end

function M.telescope()
	api.nmap("<leader>rr", ":Telescope resume<CR>", "Open last picker [telescope]")
	api.nmap("<leader>fd", ":Telescope diagnostics<CR>", "Find project [d]iagnostics [telescope]")
	api.nmap("<leader>fg", ":Telescope live_grep <CR>", "[F]ind by [g]rep pattern [telescope]")
	api.nmap("<leader>bb", ":Telescope buffers <CR>", "[B]uffer list [telescope]")
	api.nmap("<leader>fh", ":Telescope help_tags <CR>", "[F]ind [h]elp tags [telescope]")
	api.nmap("<leader>?", ":Telescope keymaps <CR>", "List all active mappings [telescope]")
	api.nmap("<leader>gb", ":Telescope git_branches <CR>", "Show [g]it [b]ranches [telescope]")
	api.nmap("<leader>gc", ":Telescope git_commits <CR>", "Show [g]it [c]ommits [telescope]")
	api.nmap("<leader>gt", ":Telescope git_status <CR>", "Run [g]it [s]tatus")
	api.nmap("<leader>sc", ":Telescope spell_suggest <CR>", "Suggest spelling [telescope]")
	api.nmap("<leader>fc", ":Telescope dotfiles <CR>", "List all dotfiles [telescope]") -- custom extension
	api.nmap("<leader>ghp", ":Telescope gh pull_request <CR>", "List all open [G]ithub [p]ull [r]equests [telescope]")
	api.nmap("<leader>ghi", ":Telescope gh issues <CR>", "List all open Github issues [telescope]")
	api.nmap(
		"<leader>ghc",
		":Telescope gh pull_request state=closed<CR>",
		"List all closed Github pull requests [telescope]"
	)
	api.nmap("<leader>fc", function()
		require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end, "[/] Search in current buffer]")

	api.nmap("<leader>th", ":Telescope colorscheme<CR>", "Toggle colorscheme [telescope]")
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

function M.fterm()
	api.nmap("<c-\\>", '<cmd>lua require("FTerm").toggle()<cr>', "Toggle terminal float [Fterm]")
	api.tmap("<c-\\>", '<c-\\><c-n><cmd>lua require("FTerm").close()<cr>', "Close terminal float [Fterm]")
end

function M.diffview()
	api.nmap("<leader>dv", "<cmd>DiffviewOpen<cr>", "Open diff view")
	api.nmap("<leader>df", "<cmd>DiffviewFileHistory %<cr>", "Open file history")
end

function M.nvim_tree()
	api.nmap("<c-n>", ":NvimTreeFindFileToggle <CR>", "Toggle file tree")
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
	api.nmap("<leader>dr", require("dap").restart, "Toggle repl [nvim-dap]")
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

return M
