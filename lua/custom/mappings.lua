local api = require("utils.api")
local utils = require("utils.helpers")

local M = {}

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

api.nmap("<leader>tw", "<CMD>set wrap!<CR>", "Toggle text wrap")

-- Don't yank on delete / change
api.nmap("d", '"_d', "Rebinds 'd' to not yank on delete (normal mode)")
api.vmap("d", '"_d', "Rebinds 'd' to not yank on delete (visual mode")
api.nmap("c", '"_c', "Rebinds 'c' to not yank on removal (normal mode)")
api.vmap("c", '"_c', "Rebinds 'c' to not yank on removal (visual mode)")

api.nmap("<A-Up>", "yyP", "Duplicate current line above")
api.nmap("<A-Down>", "yyp", "Duplicate current line below")
api.vmap("<A-Up>", "yP", "Duplicate selected lines above")
api.vmap("<A-Down>", "y'>p", "Duplicate selected lines below")

-- -- Splits
-- api.nmap("<C-h>", "<c-w>h", "Jump 1 split plane to the left")
-- api.nmap("<C-l>", "<c-w>l", "Jump 1 split plane to the right")
-- api.nmap("<C-j>", "<c-w>j", "Jump 1 split plane below")
-- api.nmap("<C-k>", "<c-w>k", "Jump 1 split plane above")

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

api.tmap("<Esc><Esc>", "<C-\\><C-n>", "Escape terminal mode")
api.map({ "n", "t" }, "<C-\\>", require("custom.terminal").toggle, "Toggle floating terminal")

-- Treesitter node selection, using the built-in `an` and `in` visual mode mappings
api.nmap("<C-Space>", "van", "Select node under cursor", { remap = true })
api.map("x", "<C-Space>", "an", "Grow selection to parent node", { remap = true })
api.map("x", "<BS>", "in", "Shrink selection to child node", { remap = true })

function M.hover()
	vim.lsp.buf.hover({
		border = "rounded",
		max_width = utils.percentage_as_width(60),
		max_height = utils.percentage_as_height(40),
	})
end

-- Convenient mouse handling
api.nmap("<2-LeftMouse>", M.hover, "Hover documentation [mouse]")
api.nmap("<M-ScrollWheelUp>", "<C-i>", "Go forward in jump list [mouse]")
api.nmap("<M-ScrollWheelDown>", "<C-o>", "Go back in jump list [mouse]")

------------------------------
-- PLUGIN SPECIFIC MAPPINGS --
------------------------------

function M.lsp(bufnr)
	local function gen_desc(desc)
		return desc .. " (LSP)"
	end

	local opts = { buf = bufnr }
	api.nmap("grn", vim.lsp.buf.rename, gen_desc("Rename"), opts)
	api.nmap("gra", vim.lsp.buf.code_action, gen_desc("Code Action"), opts)
	api.vmap("gra", vim.lsp.buf.code_action, gen_desc("Selected range Code Action"), opts)
	api.nmap("grr", "<CMD>FzfLua lsp_references<CR>", gen_desc("Goto references"), opts)

	api.nmap("gd", vim.lsp.buf.definition, gen_desc("Goto Definition"), opts)
	api.nmap("gp", require("custom.peek").definition, gen_desc("Peek definition in a floating window"), opts)
	api.nmap("gI", "<CMD>FzfLua lsp_implementations<CR>", gen_desc("Goto Implementation"), opts)
	api.nmap("<leader>D", vim.lsp.buf.type_definition, gen_desc("Type Definition"), opts)
	api.nmap("<leader>fs", "<CMD>FzfLua lsp_document_symbols<CR>", gen_desc("Document symbols"), opts)
	api.nmap("<leader>fS", "<CMD>FzfLua lsp_live_workspace_symbols<CR>", gen_desc("Workspace symbols"), opts)

	api.nmap("gl", vim.diagnostic.open_float, gen_desc("Open diagnostic error window"), opts)
	api.nmap("K", M.hover, gen_desc("Hover Documentation"), opts)
	api.imap("<C-s>", function()
		vim.lsp.buf.signature_help({
			border = "rounded",
			title = "",
			max_width = utils.percentage_as_width(50),
			max_height = utils.percentage_as_height(40),
		})
	end, gen_desc("Signature help"), opts)

	api.nmap("gD", vim.lsp.buf.declaration, gen_desc("[G]oto [D]eclaration"), opts)
	api.nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, gen_desc("[W]orkspace [A]dd Folder"), opts)
	api.nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, gen_desc("[W]orkspace [R]emove Folder"), opts)
	api.nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, gen_desc("Workspace list folders"), opts)
end

function M.undotree()
	api.nmap("<leader>uu", "<CMD>UndotreeToggle<CR>", "Toggle undo tree")
end

function M.gitsigns(bufnr)
	local gs = require("gitsigns")
	local default_opts = { buf = bufnr }

	-- Navigation
	api.nmap("]c", function()
		if vim.wo.diff then
			vim.cmd.normal({ "]c", bang = true })
		else
			gs.nav_hunk("next")
		end
	end, "Navigate to next hunk [gitsigns]", default_opts)

	api.nmap("[c", function()
		if vim.wo.diff then
			vim.cmd.normal({ "[c", bang = true })
		else
			gs.nav_hunk("prev")
		end
	end, "Navigate to previous hunk [gitsigns]", default_opts)

	-- Actions
	api.map(
		{ "n", "v" },
		"<leader>hs",
		"<CMD>Gitsigns stage_hunk<CR>",
		"Stage hunk under cursor, or unstage it if already staged [gitsigns]",
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

	-- Text object
	api.map(
		{ "o", "x" },
		"ih",
		"<CMD><C-U>Gitsigns select_hunk<CR>",
		"Motion for inside git hunk [gitsigns]",
		default_opts
	)
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
	api.nmap("<leader>th", "<CMD>FzfLua colorschemes<CR>", "Colorscheme picker [fzf-lua]")
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

function M.codecompanion()
	api.map({ "n", "x" }, "<leader>cc", "<CMD>CodeCompanionChat Toggle<CR>", "Toggle copilot chat [CodeCompanion]")
	api.map({ "n", "x" }, "<leader>ca", "<CMD>CodeCompanionActions<CR>", "Open action palette [CodeCompanion]")
end

function M.dap_ui()
	api.nmap("<leader>du", require("dapui").toggle, "Toggle DAP UI [nvim-dap-ui]")
end

function M.dap()
	api.nmap("<leader>dd", require("dap").continue, "Debugger continue [nvim-dap]")
	api.nmap("<leader>dL", require("dap").run_last, "Run the last debug configuration again [nvim-dap]")
	api.nmap("<leader>dx", require("dap").disconnect, "Debugger disconnect [nvim-dap]")
	api.nmap("<leader>db", require("dap").toggle_breakpoint, "Toggle breakpoint [nvim-dap]")
	api.nmap("<leader>dB", require("dap").clear_breakpoints, "Clear all breakpoints [nvim-dap]")
	api.nmap("<leader>dr", require("dap").restart, "Debugger restart [nvim-dap]")
	api.nmap("<leader>ds", require("dap").terminate, "Debugger terminate [nvim-dap]")
	api.nmap("<leader>do", require("dap").step_over, "Step over [nvim-dap]")
	api.nmap("<leader>dO", require("dap").step_out, "Step out [nvim-dap]")
	api.nmap("<leader>di", require("dap").step_into, "Step into [nvim-dap]")
	api.nmap("<leader>dk", function()
		-- nvim-dap draws its floats with 'winborder', which is empty by default
		require("dap.ui.widgets").hover(nil, { border = "rounded" })
	end, "View value under cursor [nvim-dap]")

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
end

function M.leap()
	api.map({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", "Leap forward")
	api.map({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", "Leap backward")
	api.nmap("gs", "<Plug>(leap-from-window)", "Leap from window")
end

function M.treesitter_textobjects(bufnr)
	local select = require("nvim-treesitter-textobjects.select")
	local move = require("nvim-treesitter-textobjects.move")
	local swap = require("nvim-treesitter-textobjects.swap")
	local opts = { buf = bufnr }

	-- `select` is the letter after `a` and `i`. `next` and `prev` are the move keys; block has none so that `]b`
	-- and `[b` keep the default `:bnext` and `:bprevious`. `@statement` has no `.inner` capture in any language,
	-- so it has no `is`.
	local objects = {
		{ select = "a", next = "]a", prev = "[a", query = "@parameter", name = "parameter" },
		{ select = "f", next = "]f", prev = "[f", query = "@function", name = "function" },
		{ select = "c", next = "]]", prev = "[[", query = "@class", name = "class" },
		{ select = "i", next = "]i", prev = "[i", query = "@conditional", name = "conditional" },
		{ select = "l", next = "]l", prev = "[l", query = "@loop", name = "loop" },
		{ select = "b", query = "@block", name = "block" },
		{ select = "m", next = "]m", prev = "[m", query = "@call", name = "call" },
		{ select = "s", next = "]s", prev = "[s", query = "@statement", name = "statement", inner = false },
	}

	for _, o in ipairs(objects) do
		api.map({ "x", "o" }, "a" .. o.select, function()
			select.select_textobject(o.query .. ".outer", "textobjects")
		end, "Select around " .. o.name, opts)
		if o.inner ~= false then
			api.map({ "x", "o" }, "i" .. o.select, function()
				select.select_textobject(o.query .. ".inner", "textobjects")
			end, "Select inside " .. o.name, opts)
		end

		if o.next then
			api.map({ "n", "x", "o" }, o.next, function()
				move.goto_next_start(o.query .. ".outer", "textobjects")
			end, "Move to the next " .. o.name, opts)
			api.map({ "n", "x", "o" }, o.prev, function()
				move.goto_previous_start(o.query .. ".outer", "textobjects")
			end, "Move to the previous " .. o.name, opts)
		end
	end

	api.nmap("<leader>sa", function()
		swap.swap_next("@parameter.inner")
	end, "Swap current parameter with next", opts)
	api.nmap("<leader>sA", function()
		swap.swap_previous("@parameter.inner")
	end, "Swap current parameter with previous", opts)
end

function M.tmux_navigator()
	api.nmap("<C-h>", "<CMD>TmuxNavigateLeft<CR>", "Navigate to neovim or tmux pane to the left")
	api.nmap("<C-l>", "<CMD>TmuxNavigateRight<CR>", "Navigate to neovim or tmux pane to the right")
	api.nmap("<C-j>", "<CMD>TmuxNavigateDown<CR>", "Navigate to neovim or tmux pane below")
	api.nmap("<C-k>", "<CMD>TmuxNavigateUp<CR>", "Navigate to neovim or tmux pane above")
end

return M
