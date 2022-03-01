-- This is used by menuHammer
-- Menuhammer is loaded in init.lua
-- https://github.com/FryJay/MenuHammer
-- openTerminal = {cons.cat.action, '', 'T', "Terminal", {
--     {cons.act.launcher, 'Terminal'}
-- }}
-- https://github.com/cldwalker/hammerspoon-files/blob/0bdeb21a4764bf8fafe9fb2b67de9fff7e902f94/menuHammerCustomConfig.lua
menuHammerMenuList = {
    mainMenu = {
        parentMenu = nil,
        -- menuHotkey = {{'alt'}, 'space'},
        menuHotkey = {hyper, 'F'},
        menuItems =  {
            {cons.cat.submenu, '', 'O', 'Open', {{cons.act.menu, "openMenu"}}},
            {cons.cat.action, '', '1', 'VSCode',  {{cons.act.launcher, 'Visual Studio Code'}}},
            {cons.cat.action, '', '2', 'Iterm',   {{cons.act.launcher, 'Iterm'}}},
            {cons.cat.action, '', '3', 'Firefox', {{cons.act.launcher, 'Firefox'}}},
            {cons.cat.action, '', '4', 'Slack',   {{cons.act.launcher, 'Slack'}}},
            {cons.cat.action, '', '0', 'Spotify', {{cons.act.launcher, 'Spotify'}}},
        }
    },
    openMenu = openMenu
}

openMenu = {cons.cat.action, '', 'T', 'Iterm', {{cons.act.launcher, 'Iterm'}}}

-- -- Use to get name of application
-- -- hs.hotkey.bind(hyper, '8', function()
-- --   print(hs.application.find('code'))
-- -- end)
-- hs.hotkey.bind(hyper, 't', 'Tabs', function()
--   app = hs.application.frontmostApplication()
--   hs.tabs.enableForApp(app)
-- end)

