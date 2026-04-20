hyper = { "cmd", "alt" }

hs.loadSpoon("HSKeybindings")
hs.loadSpoon("ReloadConfiguration")
hs.loadSpoon("SpoonInstall")
Install = spoon.SpoonInstall

hs.window.animationDuration = 0

Install:andUse("FadeLogo", {
	config = { default_run = 1.0 },
	start = true,
})

menuHammer = hs.loadSpoon("MenuHammer")
menuHammer:enter()

-- Auto-toggle kanata based on ZSA keyboard connection
local function isZSAConnected()
    local usb = hs.usb.attachedDevices()
    if not usb then return false end
    for _, device in ipairs(usb) do
        local name = (device.productName or ""):lower()
        if name:find("voyager") or name:find("zsa") or name:find("ergodox") or name:find("moonlander") then
            return true
        end
    end
    return false
end

local function startKanata()
    hs.execute("launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.kanata.plist 2>/dev/null")
end

local function stopKanata()
    hs.execute("launchctl bootout gui/$(id -u)/com.kanata 2>/dev/null")
end

local usbWatcher = hs.usb.watcher.new(function(device)
    local name = (device.productName or ""):lower()
    if name:find("voyager") or name:find("zsa") or name:find("ergodox") or name:find("moonlander") then
        if device.eventType == "added" then
            stopKanata()
        elseif device.eventType == "removed" then
            startKanata()
        end
    end
end)
usbWatcher:start()

-- Start kanata now if ZSA is not connected
if not isZSAConnected() then
    startKanata()
end

-- Game layer toggle with menu bar indicator
-- Communicates with kanata via TCP (127.0.0.1:7070, set in ~/.config/kanata/config.kbd)
-- Game layer disables homerow mods and nav layer (hold-w arrows)
-- Toggle: hyper+g (Cmd+Alt+g)
local gameModeActive = false
local gameModeMenuItem = nil

local function updateGameModeUI(active)
    gameModeActive = active
    if active then
        if not gameModeMenuItem then
            gameModeMenuItem = hs.menubar.new()
        end
        if gameModeMenuItem then
            gameModeMenuItem:setTitle("GAME")
        end
    else
        if gameModeMenuItem then
            gameModeMenuItem:delete()
            gameModeMenuItem = nil
        end
    end
end

local function setGameMode(active)
    updateGameModeUI(active)
    local layer = active and "game" or "base"
    hs.execute('echo \'{"ChangeLayer":{"new":"' .. layer .. '"}}\' | nc -w1 127.0.0.1 7070 2>/dev/null')
end

-- Sync game mode state from kanata on startup
-- Kanata sends a LayerChange event on new TCP connections with the current layer
local function syncGameModeFromKanata()
    local output = hs.execute('echo "" | nc -w1 127.0.0.1 7070 2>/dev/null')
    if output and output:find('"game"') then
        updateGameModeUI(true)
    else
        updateGameModeUI(false)
    end
end
syncGameModeFromKanata()

hs.hotkey.bind(hyper, "g", "Toggle Game Mode", function()
    setGameMode(not gameModeActive)
end)

require("src/firefox-tabs")
require("src/clipboard")
