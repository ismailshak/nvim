local utils = require("utils.helpers")
if not utils.exists("dashboard") then
	return
end

local dashboard = require("dashboard")

local M = {}

M.custom_header = {
	[[ ]],
	[[ ]],
	[[ ]],
	[[                                                     ___'        ]],
	[[                                                 ,o88888'        ]],
	[[                                               ,o8888888''       ]],
	[[                         ,:o:o:oooo.        ,7O88Pd8888"'        ]],
	[[                     ,.::.::o:ooooOoOoO. ,oO8O8Pd888'"'          ]],
	[[                   ,.:.::o:ooOoOoOO8O8OOo.8OOPd8O8O"'            ]],
	[[                  , ..:.::o:ooOoOOOO8OOOOo.FdO8O8"'              ]],
	[[                 , ..:.::o:ooOoOO8O888O8O,COCOO"'                ]],
	[[                , . ..:.::o:ooOoOOOO8OOOOCOCO"'                  ]],
	[[                 . ..:.::o:ooOoOoOO8O8OCCCC"o'                   ]],
	[[                    . ..:.::o:ooooOoCoCCC"o:o'                   ]],
	[[                    . ..:.::o:o:,cooooCo"oo:o:'                  ]],
	[[                 `   . . ..:.:cocoooo"'o:o:::''                  ]],
	[[                 .`   . ..::ccccoc"'o:o:o:::''                   ]],
	[[                :.:.    ,c:cccc"':.:.:.:.:.''                    ]],
	[[              ..:.:"'`::::c:"'..:.:.:.:.:.''                     ]],
	[[            ...:.'.:.::::"'    . . . . .''                       ]],
	[[           .. . ....:."' `   .  . . '''                          ]],
	[[         . . . ...."''                                           ]],
	[[         .. . ."' '                                              ]],
	[[        .'                                                       ]],
	[[ ]],
	[[ ]],
	[[ ]],
}

M.gen_custom_footer = function()
	local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	local count = utils.get_loaded_plugin_count()
	local dir_line = " " .. dir_name
	local plugin_line = "No plugins loaded"
	if count > 0 then
		plugin_line = "loaded " .. count .. " plugins"
	end
	return { "", "", dir_line, "", "", plugin_line }
end
-- dashboard.preview_file_height = 12
-- dashboard.preview_file_width = 80
dashboard.setup({
	theme = "doom",
	hide = {
		tabline = true,
		winbar = true,
		statusline = true,
	},
	preview = {
		file_height = 12,
		file_width = 80,
	},
	config = {
		header = M.custom_header,
		center = {
			{
				icon = "  ",
				desc = "Load last session                       ",
				key = "s",
				keymap = "SPC s l",
				action = "RestoreSession",
				icon_hl = "DashboardIcon",
			},
			{
				icon = "  ",
				desc = "Find file                               ",
				action = "Telescope find_files",
				keymap = "SPC f f",
			},
			{
				icon = "ﳳ  ",
				desc = "Find word                               ",
				action = "Telescope live_grep",
				key = "g",
				keymap = "SPC f g",
			},
			{
				icon = "ﴳ  ",
				desc = "Search buffers                          ",
				action = "Telescope buffers",
				key = "b",
				keymap = "SPC b b",
			},
			{
				icon = "  ",
				desc = "Open doftile                            ",
				action = "Telescope dotfiles",
				key = "d",
				keymap = "SPC f c",
			},
		},
		footer = M.gen_custom_footer(),
	},
})

M.custom_header_disabled = {
	[[                               ]],
	[[                               ]],
	[[                               ]],
	[[                               ]],
	[[                               ]],
	[[   ▄████▄              ▒▒▒▒▒   ]],
	[[  ███▄█▀              ▒ ▄▒ ▄▒  ]],
	[[ ▐████     █  █  █   ▒▒▒▒▒▒▒▒▒ ]],
	[[  █████▄             ▒▒▒▒▒▒▒▒▒ ]],
	[[   ▀████▀            ▒ ▒ ▒ ▒ ▒ ]],
	[[                               ]],
	[[                               ]],
	[[                               ]],
	[[                               ]],
}
