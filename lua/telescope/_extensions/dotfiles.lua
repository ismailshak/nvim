local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local action_state = require("telescope.actions.state")

local dotfile_list = require("telescope._extensions.list").dots

local function action(dot)
	vim.cmd("e " .. dot.path)
end

local function dotfiles(opts)
	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 2 },
			{ width = 20 },
			{ width = 25 },
			{ remaining = true },
		},
	})
	local make_display = function(entry)
		return displayer({
			{ entry.icon, "Identifier" },
			entry.name,
			entry.description,
			{ entry.path, "Comment" },
		})
	end

	pickers.new(opts, {
		prompt_title = "Dotfiles",
		sorter = conf.generic_sorter(opts),
		finder = finders.new_table({
			results = dotfile_list,
			entry_maker = function(dot)
				return {
					ordinal = dot.name .. dot.path .. dot.description,
					display = make_display,

					icon = dot.icon,
					name = dot.name,
					description = dot.description,
					path = dot.path,
				}
			end,
		}),
		layout_strategy = "horizontal",
		layout_config = {
			width = 0.45,
			height = 0.50,
		},
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				local selected_dot = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				action(selected_dot)
			end)
			return true
		end,
	}):find()
end

return require("telescope").register_extension({
	setup = function(config)
		action = config.action or action
	end,
	exports = { dotfiles = dotfiles },
})
