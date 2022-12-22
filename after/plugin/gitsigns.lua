local helpers = require("utils.helpers")
if not helpers.exists("gitsigns") then
	return
end

local utils = require("utils.keybindings")

require("gitsigns").setup({
	signs = {
		add = { hl = "GitSignsAdd", text = "|", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = { hl = "GitSignsChange", text = "|", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
	},
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	attach_to_untracked = true,
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 500,
		ignore_whitespace = false,
	},
	--current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
	current_line_blame_formatter = "        <author>, <author_time:%R> - <summary>",
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000,
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	yadm = {
		enable = false,
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, desc, opts)
			opts = opts or {}
			opts.buffer = bufnr
			utils.map(mode, l, r, desc, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, "Navigate to next hunk [gitsigns]", { expr = true })

		map("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, "Navigate to previous hunk [gitsigns]", { expr = true })

		-- Actions
		map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage hunk under cursor [gitsigns]")
		map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset hunk under cursor [gitsigns]")
		map("n", "<leader>hS", gs.stage_buffer, "Stage the current buffer [gitsigns]")
		map("n", "<leader>hu", gs.undo_stage_hunk, "Undo staging of hunk [gitsigns]")
		map("n", "<leader>hR", gs.reset_buffer, "Reset the current buffer [gitsigns]")
		map("n", "<leader>hp", gs.preview_hunk, "Previw hunk under cursor [gitsigns]")
		map("n", "<leader>hb", function()
			gs.blame_line({ full = true })
		end, "Show blame for line under cursor [gitsigns]")
		map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle blame for current line [gitsigns]")
		map("n", "<leader>hd", gs.diffthis, "Diff this [gitsigns]")
		map("n", "<leader>hD", function()
			gs.diffthis("~")
		end, "Diff this ~ [gitsigns]")
		map("n", "<leader>td", gs.toggle_deleted, "Toggle deleted [gitsigns]")

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Not sure [gitsigns]")
	end,
})
