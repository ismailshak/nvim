local utils = require("utils.helpers")
if not utils.exists("dashboard") then
	return
end

local dashboard = require("dashboard")
--
-- dashboard.preview_file_height = 12
-- dashboard.preview_file_width = 80
-- dashboard.utils.hide_statusline = true
-- dashboard.utils.hide_tabline = true
-- dashboard.header_pad = 5
-- dashboard.center_pad = 5
-- dashboard.footer_pad = 5
--
local function make_custom_footer()
	local default_footer = { "", "No plugins loaded" }
	local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	default_footer[1] = " " .. dir_name
	local count = utils.get_loaded_plugin_count()
	if count > 0 then
		default_footer[2] = ""
		default_footer[3] = ""
		default_footer[4] = "loaded " .. count .. " plugins"
	end
	return default_footer
end

dashboard.custom_footer = make_custom_footer

dashboard.custom_center = {
	{
		icon = "  ",
		desc = "Load last session                       ",
		shortcut = "SPC s l",
		action = "RestoreSession",
	},
	{
		icon = "  ",
		desc = "Find file                               ",
		action = "Telescope find_files find_command=rg,--hidden,--files",
		shortcut = "SPC f f",
	},
	{
		icon = "ﳳ  ",
		desc = "Find word                               ",
		action = "Telescope live_grep",
		shortcut = "SPC f g",
	},
	{
		icon = "ﴳ  ",
		desc = "Search buffers                          ",
		action = "Telescope buffers",
		shortcut = "SPC b b",
	},
	{
		icon = "  ",
		desc = "Open doftile                            ",
		action = "Telescope dotfiles",
		shortcut = "SPC f c",
	},
}

dashboard.custom_header = {
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
}

dashboard.custom_header_disabled = {
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

utils.hi("DashboardHeader", { fg = "#85a4f2", bg = "none" }) -- lua file icon blue
utils.hi("DashboardCenter1Icon", { fg = "#85a4f2", bg = "none" })
utils.hi("DashboardCenter3Icon", { fg = "#85a4f2", bg = "none" })
utils.hi("DashboardCenter5Icon", { fg = "#85a4f2", bg = "none" })
utils.hi("DashboardCenter7Icon", { fg = "#85a4f2", bg = "none" })
utils.hi("DashboardCenter9Icon", { fg = "#85a4f2", bg = "none" })
utils.hi("DashboardCenter11Icon", { fg = "#85a4f2", bg = "none" })
utils.hi("DashboardShortCut", { fg = "#85a4f2", bg = "none" })
utils.hi("DashboardFooter", { fg = "#7c7f96", bg = "none" })

--utils.hi("DashboardHeader", { fg = "#ebbcba", bg = "none" }) -- rose pine, rose
--utils.hi("DashboardCenter1Icon", { fg = "#696778", bg = "none" })
--utils.hi("DashboardCenter3Icon", { fg = "#696778", bg = "none" })
--utils.hi("DashboardCenter5Icon", { fg = "#696778", bg = "none" })
--utils.hi("DashboardCenter7Icon", { fg = "#696778", bg = "none" })
