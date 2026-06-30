hyper = { "cmd", "alt" }

-- Enable the `hs` command-line tool (message port) for scripting/diagnostics.
require("hs.ipc")

hs.loadSpoon("HSKeybindings")
hs.loadSpoon("ReloadConfiguration")
-- Actually start the config pathwatcher. Without :start() the spoon is inert,
-- so Hammerspoon never auto-reloads on edits and runs stale in-memory config
-- (this silently kept old kanata logic alive and broke restarts).
spoon.ReloadConfiguration:start()
hs.loadSpoon("SpoonInstall")
Install = spoon.SpoonInstall

hs.window.animationDuration = 0

Install:andUse("FadeLogo", {
	config = { default_run = 1.0 },
	start = true,
})

menuHammer = hs.loadSpoon("MenuHammer")
menuHammer:enter()

-- Keep kanata running at all times.
--
-- kanata only grabs the built-in keyboard (see macos-dev-names-include in
-- ~/.config/kanata/config.kbd), so it never touches the ZSA Voyager. That
-- means there is no double-remap risk and no reason to stop kanata when the
-- Voyager is connected. The previous USB auto-toggle (stop on connect / start
-- on disconnect) predated that device filter and was the main cause of kanata
-- being left dead. It has been removed: kanata just stays up.
--
-- bootstrap loads the service definition (no-op if already loaded); kickstart
-- then actually (re)starts it. bootstrap alone cannot start an
-- already-loaded-but-stopped job, which previously left kanata dead after a
-- crash or a bootout.
local function startKanata()
    hs.execute("launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.kanata.plist 2>/dev/null")
    hs.execute("launchctl kickstart -k gui/$(id -u)/com.kanata 2>/dev/null")
end

startKanata()

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
