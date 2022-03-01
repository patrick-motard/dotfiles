-- This is used by menuHammer
-- Menuhammer is loaded in init.lua
-- https://github.com/FryJay/MenuHammer
menuHammerMenuList = {
    mainMenu = {
        parentMenu = nil,
        menuHotkey = {{'alt'}, 'space'},
        menuItems =  {
            -- {cons.cat.submenu, '', 'A', 'Applications', {
            --         {cons.act.menu, "applicationMenu"}
            -- }},
            {cons.cat.action, '', 'T', "Terminal", {
                    {cons.act.launcher, 'Terminal'}
            }},
            -- {cons.cat.action, '', 'D', 'Desktop', {
            --         {cons.act.launcher, 'Finder'},
            --         {cons.act.keycombo, {'cmd', 'shift'}, 'd'},
            -- }},
            -- {cons.cat.action, '', 'E', "Split Safari/iTunes", {
            --     {cons.act.func, function()
            --             -- See Hammerspoon layout documentation for more info on this
            --             local mainScreen = hs.screen{x=0,y=0}
            --             hs.layout.apply({
            --                     {"Safari", nil, mainScreen, hs.layout.left50, nil, nil},
            --                     {"iTunes", nil, mainScreen, hs.layout.right50, nil, nil},
            --             })
            --     end }
            -- }},
            -- {cons.cat.action, '', 'H', "Hammerspoon Manual", {
            --         {cons.act.func, function()
            --             hs.doc.hsdocs.forceExternalBrowser(true)
            --             hs.doc.hsdocs.moduleEntitiesInSidebar(true)
            --             hs.doc.hsdocs.help()
            --         end }
            -- }},
            -- {cons.cat.action, '', 'M', 'MenuHammer Default Config', {
            --     {cons.act.openfile, "~/.hammerspoon/Spoons/MenuHammer.spoon/MenuConfigDefaults.lua"},
            -- }},
            -- {cons.cat.action, '', 'X', "Mute/Unmute", {
            --         {cons.act.mediakey, "mute"}
            -- }},
        }
    },
    -- applicationMenu = {
    --     parentMenu = "mainMenu",
    --     menuHotkey = nil,
    --     menuItems = {
    --         {cons.cat.action, '', 'A', "App Store", {
    --                 {cons.act.launcher, 'App Store'}
    --         }},
    --     }
    -- },
}
