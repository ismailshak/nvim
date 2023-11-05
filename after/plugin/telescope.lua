local utils = require("utils.helpers")
local api = require("utils.api")

if not utils.exists("telescope") then
	return
end

local telescope = require("telescope")
local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

-- mappings
api.nmap("<leader>rr", ":Telescope resume<CR>", "Open last picker [telescope]")
api.nmap("<leader>dd", ":Telescope diagnostics<CR>", "Find project [d]iagnostics [telescope]")
api.nmap("<leader>dD", ":Telescope diagnostics<CR>", "Find buffer diagnostics [telescope]")
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
-- local persist_colorscheme = function(prompt_bufnr)
-- 	local selected_entry = actions_state.get_selected_entry()
-- 	api.save_colorscheme()
-- 	vim.cmd("colorscheme " .. selected_entry[1])
-- 	actions.close(prompt_bufnr)
-- end
--
-- api.nmap("<leader>th", function()
-- 	require("telescope.builtin").colorscheme({
-- 		attach_mappings = function(_, map)
-- 			map("n", "<cr>", persist_colorscheme)
-- 			map("i", "<cr>", persist_colorscheme)
--
-- 			-- needs to return true if you want to map default_mappings and
-- 			-- false if not
-- 			return true
-- 		end,
-- 	})
-- end, "Toggle colorscheme [telescope]")

telescope.setup({
	defaults = {
		prompt_prefix = " ",
		selection_caret = " ",
		entry_prefix = " ",
		path_display = { "smart" },
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.55,
				results_width = 0.8,
			},
			vertical = {
				mirror = false,
			},
			width = 0.87,
			height = 0.80,
			preview_cutoff = 120,
		},
		file_ignore_patterns = { "node_modules", ".git", "dist", ".next", "target", "build" },
		generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		-- path_display = { "truncate" },
		winblend = 10,
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		mappings = {
			i = {
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,

				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,

				["<C-c>"] = actions.close,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,

				["<CR>"] = actions.select_default,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,

				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<C-l>"] = actions.complete_tag,
				["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
				["<C-t>"] = trouble.open_with_trouble,
			},

			n = {
				["<esc>"] = actions.close,
				["<CR>"] = actions.select_default,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

				["j"] = actions.move_selection_next,
				["k"] = actions.move_selection_previous,
				["H"] = actions.move_to_top,
				["M"] = actions.move_to_middle,
				["L"] = actions.move_to_bottom,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,
				["gg"] = actions.move_to_top,
				["G"] = actions.move_to_bottom,

				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["?"] = actions.which_key,
				["<C-t>"] = trouble.open_with_trouble,
			},
		},
	},
	pickers = {
		-- Default configuration for builtin pickers goes here:
		-- picker_name = {
		--   picker_config_key = value,
		--   ...
		-- }
		-- Now the picker_config_key will be applied every time you call this
		-- builtin picker
		--find_files = {
		--	hidden = true, -- enable finding dot files
		--}
		colorscheme = {
			enable_preview = true,
		},
	},
	extensions = {
		media_files = {
			-- filetypes whitelist
			-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
			filetypes = { "png", "webp", "jpg", "jpeg", "pdf" },
			find_cmd = "rg", -- find command (defaults to `fd`)
		},
		dotfiles = {
			theme = "ivy",
			layout_strategy = "horizontal",
			layout_config = {
				width = 0.40,
				height = 0.50,
			},
		},
	},
})

require("telescope").load_extension("gh")
require("telescope").load_extension("dotfiles") -- this is my custom thing
