hyper = { "cmd", "alt" }

hs.loadSpoon("HSKeybindings")
hs.loadSpoon("ReloadConfiguration")
hs.loadSpoon("KSheet")
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
    hs.execute("launchctl load /Library/LaunchDaemons/com.kanata.plist 2>/dev/null")
end

local function stopKanata()
    hs.execute("launchctl unload /Library/LaunchDaemons/com.kanata.plist 2>/dev/null")
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
