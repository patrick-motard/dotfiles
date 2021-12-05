Install:andUse('KSheet', {
  hotkeys = {
    toggle = { leader, '/' }
  }
})

local cheatsheetToggle = true
function toggleCheatSheet()
  if cheatsheetToggle then
    spoon.HSKeybindings:show()
  else
    spoon.HSKeybindings:hide()
  end
  cheatsheetToggle = not cheatsheetToggle
end
hs.hotkey.bind(leader, 'h', 'Show Keybinds', toggleCheatSheet)

