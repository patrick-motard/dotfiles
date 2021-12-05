function connectToVPN(e)
  -- if e == hs.caffeinate.watcher.screensDidUnlock then
  hs.applescript([[
    ignoring application responses
      tell application "System Events" to tell process "GlobalProtect"
        click menu bar item 1 of menu bar 2
      end tell
    end ignoring
    do shell script "killall System\\ Events"
    delay 0.1
    tell application "System Events" to tell process "GlobalProtect"
      tell menu bar item 1 of menu bar 2
        if exists menu item "Connect to" of menu 1
          tell menu item "Connect to" of menu 1
            click
            click menu item "APAC" of menu 1
          end tell
        end if
      end tell
    end tell
  ]])
  -- end
end

function startCaffienateWatcher()
  caffeinateWatcher = hs.caffeinate.watcher.new(connectToVPN):start()
end
