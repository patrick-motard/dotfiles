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

local function setAudioOutput(pattern)
    local devices = hs.audiodevice.allOutputDevices()
    for _, dev in ipairs(devices) do
        if dev:name():lower():find(pattern) then
            dev:setDefaultOutputDevice()
            hs.notify.new({ informativeText = "Audio output: " .. dev:name() }):send()
            return
        end
    end
    hs.notify.new({ informativeText = "Audio device not found: " .. pattern }):send()
end

menuHammerMenuList = {
    mainMenu = {
        parentMenu = nil,
        menuHotkey = { hyper, "m" },
        menuItems = {
            { cons.cat.action, "", "r", "Reload Hammerspoon", { { cons.act.func, function()
                hs.notify.new({ informativeText = "Reloading Hammerspoon." }):send()
                hs.reload()
            end } } },
            { cons.cat.action, "", "t", "Firefox Tab Search", { { cons.act.func, function()
                showTabChooser()
            end } } },
            { cons.cat.action, "", "b", "Firefox Bookmark Search", { { cons.act.func, function()
                showBookmarkChooser()
            end } } },
            { cons.cat.action, "", "k", "Restart Kanata", { { cons.act.func, function()
                hs.execute("launchctl unload ~/Library/LaunchAgents/com.kanata.plist && launchctl load ~/Library/LaunchAgents/com.kanata.plist")
                hs.notify.new({ informativeText = "Kanata restarted." }):send()
            end } } },
            { cons.cat.submenu, "", "s", "Audio Output", { { cons.act.menu, "audioMenu" } } },
        },
    },
    audioMenu = {
        parentMenu = "mainMenu",
        menuItems = {
            { cons.cat.action, "", "1", "Speakers (MacBook Pro)", { { cons.act.func, function()
                setAudioOutput("macbook pro")
            end } } },
            { cons.cat.action, "", "2", "TX Speakers", { { cons.act.func, function()
                setAudioOutput("^tx")
            end } } },
            { cons.cat.action, "", "3", "Schiit Headphones", { { cons.act.func, function()
                setAudioOutput("^schi")
            end } } },
        },
    },
}
