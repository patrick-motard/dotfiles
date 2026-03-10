-- MenuHammer config - https://github.com/FryJay/MenuHammer

-- Styling
menuItemFont = "JetBrainsMono-Regular"
menuItemFontSize = 14
menuNumberOfColumns = 3
menuMinNumberOfRows = 3
menuRowHeight = 24
menuOuterPadding = 24
menuItemTextAlign = "left"

menuItemColors = {
    default      = { background = "#282828", text = "#ebdbb2" },
    exit         = { background = "#282828", text = "#fb4934" },
    back         = { background = "#282828", text = "#fe8019" },
    submenu      = { background = "#282828", text = "#83a598" },
    navigation   = { background = "#282828", text = "#83a598" },
    action       = { background = "#282828", text = "#b8bb26" },
    empty        = { background = "#282828", text = "#665c54" },
    display      = { background = "#282828", text = "#a89984" },
    menuBarActive = { background = "#282828", text = "#fabd2f" },
    menuBarIdle   = { background = "#282828", text = "#665c54" },
}

menuHammerMenuList = {
    mainMenu = {
        parentMenu = nil,
        menuHotkey = { hyper, "m" },
        menuItems = {
            { cons.cat.action, "", "r", "Reload Hammerspoon", { { cons.act.func, function()
                hs.notify.new({ informativeText = "Reloading Hammerspoon." }):send()
                hs.reload()
            end } } },
            { cons.cat.action, "", "k", "Show Keybindings", { { cons.act.func, function()
                spoon.HSKeybindings:show()
            end } } },
            { cons.cat.action, "", "/", "KSheet Toggle", { { cons.act.func, function()
                spoon.KSheet:toggle()
            end } } },
        },
    },
}
