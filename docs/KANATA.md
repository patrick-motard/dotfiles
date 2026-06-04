# Kanata - Keyboard Remapping

Kanata provides a full Colemak-DH matrix layout with homerow mods, managed as a macOS user service.

## Layout

The OS keyboard is set to **QWERTY** - kanata handles all remapping.

### Colemak-DH Matrix

```
grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
tab  q    w    f    p    b    j    l    u    y    ;    [    ]    \
esc  a    r    s    t    g    m    n    e    i    o    '    ret
lsft z    x    c    d    v    k    h    ,    .    /    rsft
```

### Homerow Mods

Hold homerow keys to activate modifiers (240ms tapping term):

| Key (Colemak) | Tap | Hold |
|---------------|-----|------|
| A | a | Left Alt |
| R | r | Left Ctrl |
| S | s | Left Gui (Cmd) |
| T | t | Left Shift |
| N | n | Right Shift |
| E | e | Right Gui (Cmd) |
| I | i | Right Ctrl |
| O | o | Right Alt |

### Layers

- **Base**: Colemak-DH with homerow mods
- **Nav**: Hold `w` to activate arrow keys on `m/n/e/i` (left/down/up/right), mirrors ZSA Voyager layer 2
- **Game**: Plain Colemak without homerow mods or nav layer, toggled via Hammerspoon (`Cmd+Alt+g`)

## Components

- **Config**: `~/.config/kanata/config.kbd`
- **LaunchAgent**: `~/Library/LaunchAgents/com.kanata.plist`
- **App bundle**: `/Applications/Kanata.app`
- **Sudoers**: `/etc/sudoers.d/kanata`
- **TCP server**: Listens on `127.0.0.1:7070` for layer switching commands

## Hammerspoon Integration

Hammerspoon manages kanata lifecycle and provides a game mode toggle:

- **Auto-toggle**: USB watcher stops kanata when a ZSA keyboard is connected, starts it when disconnected
- **Game mode**: `Cmd+Alt+g` switches to the game layer via TCP and shows "GAME" in the macOS menu bar

## Setup Notes

- Install the Karabiner virtual HID driver (`karabiner-elements`) so Kanata can expose a virtual keyboard device.
- Grant Input Monitoring permission to `Kanata.app` in macOS Privacy & Security settings.
- Keep the macOS input source set to standard U.S. QWERTY.

## Troubleshooting

### Check logs

```bash
tail -f /tmp/kanata.log
```

### Manually restart

```bash
launchctl kickstart -k gui/$(id -u)/com.kanata
```

### `IOHIDDeviceOpen error: not permitted Apple Internal Keyboard`

This error is **expected and harmless**. Kanata uses the Karabiner virtual HID driver rather than direct HID access. As long as you see `driver connected: true` and `Starting kanata proper`, it's working.

### Keys not remapping after reboot

Check that `Kanata.app` is still in Input Monitoring. macOS occasionally removes permissions after system updates - re-add it if needed.

### Homerow mods triggering accidentally

The 240ms tapping term may be too short or too long. Adjust the two `240` values in each `tap-hold` entry in `~/.config/kanata/config.kbd`, then restart Kanata.

### Game mode not working

Verify the TCP server is running: `echo '{}' | nc -w1 127.0.0.1 7070`. You should get a JSON response with the current layer. If not, check that Kanata was started with the `-p 127.0.0.1:7070` flag.
