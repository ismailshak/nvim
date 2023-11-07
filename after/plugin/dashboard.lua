local utils = require("utils.helpers")
local api = require("utils.api")

if not utils.exists("dashboard") then
	return
end

local dashboard = require("dashboard")

local M = {}

M.custom_header_disabled = {
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

M.custom_header = {
	[[ ]],
	[[ ]],
	[[ ]],
	[[ ]],
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
	[[]],
	[[]],
	[[]],
	[[]],
}

function M.gen_custom_footer()
	local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	local count = api.get_plugin_count()
	local dir_line = "󰉖 " .. dir_name
	local plugin_line = "No plugins"
	if count > 0 then
		plugin_line = count .. " plugins"
	end
	return { "", "", dir_line, "", plugin_line }
end

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
				action = "RestoreSession",
				icon_hl = "DashboardIcon",
				key = "s",
				keymap = "SPC s l",
			},
			{
				icon = "  ",
				desc = "Find file                               ",
				action = "lua require('fzf-lua').files()",
				key = "f",
				keymap = "SPC f f",
			},
			{
				icon = "󰟵  ",
				desc = "Find word                               ",
				action = "Telescope live_grep",
				key = "g",
				keymap = "SPC f g",
			},
			{
				icon = "󰠵  ",
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
