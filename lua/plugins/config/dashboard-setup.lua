local ok, dashboard = pcall(require, "dashboard")
if not ok then
	return
end

local home = os.getenv("HOME")

dashboard.preview_file_height = 12
dashboard.preview_file_width = 80
dashboard.hide_statusline = false
dashboard.hide_tabline = false
dashboard.header_pad = 5
dashboard.center_pad = 7
dashboard.footer_pad = 5

local function make_custom_footer()
	local default_footer = { "", "No plugins loaded" }
	if packer_plugins ~= nil then
		local count = #vim.tbl_keys(packer_plugins)
		default_footer[2] = "loaded " .. count .. " plugins"
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
		icon = "  ",
		desc = "File browser                            ",
		action = "Telescope file_browser",
		shortcut = "SPC f b",
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
		shortcut = "SPC b l",
	},
	{
		icon = "  ",
		desc = "Open zshrc                              ",
		action = "Telescope dotfiles path=" .. home .. "/code/dotfiles",
		shortcut = "SPC z r",
	},
}

dashboard.custom_header = {
	[[                                                     ___'        ]],
	[[                                                 ,o88888'        ]],
	[[                                               ,o8888888''       ]],
	[[                         ,:o:o:oooo.        ,8O88Pd8888"'        ]],
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

local hi = vim.api.nvim_set_hl

hi(0, "DashboardHeader", { fg = "#85a4f2", bg = "none" }) -- lua file icon blue
hi(0, "DashboardCenter1Icon", { fg = "#85a4f2", bg = "none" })
hi(0, "DashboardCenter3Icon", { fg = "#85a4f2", bg = "none" })
hi(0, "DashboardCenter5Icon", { fg = "#85a4f2", bg = "none" })
hi(0, "DashboardCenter7Icon", { fg = "#85a4f2", bg = "none" })
hi(0, "DashboardCenter9Icon", { fg = "#85a4f2", bg = "none" })
hi(0, "DashboardCenter11Icon", { fg = "#85a4f2", bg = "none" })
hi(0, "DashboardShortCut", { fg = "#85a4f2", bg = "none" })
hi(0, "DashboardFooter", { fg = "#7c7f96", bg = "none" })

--hi(0, "DashboardHeader", { fg = "#ebbcba", bg = "none" }) -- rose pine, rose
--hi(0, "DashboardCenter1Icon", { fg = "#696778", bg = "none" })
--hi(0, "DashboardCenter3Icon", { fg = "#696778", bg = "none" })
--hi(0, "DashboardCenter5Icon", { fg = "#696778", bg = "none" })
--hi(0, "DashboardCenter7Icon", { fg = "#696778", bg = "none" })
