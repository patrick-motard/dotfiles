-- This is used by menuHammer
-- Menuhammer is loaded in init.lua
-- https://github.com/FryJay/MenuHammer
-- https://github.com/cldwalker/hammerspoon-files/blob/0bdeb21a4764bf8fafe9fb2b67de9fff7e902f94/menuHammerCustomConfig.lua
menuHammerMenuList = {
	mainMenu = {
		parentMenu = nil,
		-- menuHotkey = {{'alt'}, 'space'},
		menuHotkey = { hyper, "m" },
		menuItems = {
			{ cons.cat.submenu, "", "O", "Open", { { cons.act.menu, "openMenu" } } },
			{ cons.cat.action, "", "1", "VSCode", { { cons.act.launcher, "Visual Studio Code" } } },
			{ cons.cat.action, "", "2", "Alacritty", { { cons.act.launcher, "Alacritty" } } },
			{ cons.cat.action, "", "3", "Firefox", { { cons.act.launcher, "Firefox" } } },
			{ cons.cat.action, "", "4", "Slack", { { cons.act.launcher, "Slack" } } },
			{ cons.cat.action, "", "0", "Spotify", { { cons.act.launcher, "Spotify" } } },
		},
	},
	openMenu = {
		parentMenu = "mainMenu",
		menuHotkey = nil,
		menuItems = {
			{ cons.cat.action, "", "T", "Iterm", { { cons.act.launcher, "Iterm" } } },
			{
				cons.cat.action,
				"",
				"H",
				"Hints",
				{ {
					cons.act.func,
					function()
						openHints()
					end,
				} },
			},
		},
	},
}

openHints = function()
	hs.hints.showTitleThresh = 10
	-- hs.hints.style = 'vimperator'
	hs.hints.windowHints()
end

-- -- Use to get name of application
-- -- hs.hotkey.bind(hyper, '8', function()
-- --   print(hs.application.find('code'))
-- -- end)
-- hs.hotkey.bind(hyper, 't', 'Tabs', function()
--   app = hs.application.frontmostApplication()
--   hs.tabs.enableForApp(app)
-- end)
