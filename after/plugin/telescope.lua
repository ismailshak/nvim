local helpers = require("utils.helpers")
if not helpers.exists("telescope") then
	return
end

local telescope = require("telescope")

-- keybings
local utils = require("utils.keybindings")
utils.nmap("<leader>ff", ":Telescope find_files hidden=true no_ignore=true<CR>", "[F]ind [f]iles [telescope]")
utils.nmap("<leader>fg", ":Telescope live_grep <CR>", "[F]ind by [g]rep pattern [telescope]")
utils.nmap("<leader>fb", ":Telescope file_browser <CR>", "[F]ile [b]rowser [telescope]")
utils.nmap("<leader>bb", ":Telescope buffers <CR>", "[B]uffer list [telescope]")
utils.nmap("<leader>fh", ":Telescope help_tags <CR>", "[F]ind [h]elp tags [telescope]")
utils.nmap("<leader>?", ":Telescope keymaps <CR>", "List all active mappings [telescope]")
utils.nmap("<leader>gb", ":Telescope git_branches <CR>", "Show [g]it [b]ranches [telescope]")
utils.nmap("<leader>gc", ":Telescope git_commits <CR>", "Show [g]it [c]ommits [telescope]")
utils.nmap("<leader>gt", ":Telescope git_status <CR>", "Run [g]it [s]tatus")
utils.nmap("<leader>fo", ":Telescope oldfiles <CR>", "[F]ind [o]ld files [telescope]")
utils.nmap("<leader>th", ":Telescope colorscheme <CR>", "[T]oggle [c]olorscheme [telescope]")
utils.nmap("<leader>sc", ":Telescope spell_suggest <CR>", "Suggest spelling [telescope]")
utils.nmap("<leader>fc", ":Telescope dotfiles <CR>", "List all dotfiles [telescope]") -- custom extension
utils.nmap("<leader>ghp", ":Telescope gh pull_request <CR>", "List all open [G]ithub [p]ull [r]equests [telescope]")
utils.nmap(
	"<leader>ghc",
	":Telescope gh pull_request state=closed<CR>",
	"List all closed Github pull requests [telescope]"
)
utils.nmap("<leader>ghi", ":Telescope gh issues <CR>", "List all open Github issues [telescope]")
utils.nmap("<leader>fc", function()
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, "[/] Search in current buffer]")

local actions = require("telescope.actions")

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
				["<C-t>"] = actions.select_tab,

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
			},

			n = {
				["<esc>"] = actions.close,
				["<CR>"] = actions.select_default,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

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
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
		},
	},
})

require("telescope").load_extension("gh")
require("telescope").load_extension("dotfiles") -- this is my custom thing
require("telescope").load_extension("fzf")
