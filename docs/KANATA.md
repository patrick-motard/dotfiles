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

## Architecture

### Why an App Bundle?

macOS requires Input Monitoring permission for any process that intercepts keystrokes. This permission can only be granted to `.app` bundles, not raw CLI binaries. The workaround:

1. A minimal app bundle lives at `/Applications/Kanata.app`
2. The bundle's executable is the actual kanata binary (not a wrapper script)
3. macOS shows `Kanata.app` in Privacy & Security > Input Monitoring
4. A user LaunchAgent runs the binary via `sudo` at login

### Why a LaunchAgent (not LaunchDaemon)?

LaunchDaemons run in the system domain, which doesn't have access to the user's TCC (Input Monitoring) permissions. A LaunchAgent runs in the user session where the permission applies, then uses `sudo` for the root access kanata needs.

### Components

- **Config**: `~/.config/kanata/config.kbd` (managed by chezmoi)
- **Plist source**: `~/.config/kanata/com.kanata.plist` (copied by ansible)
- **App bundle**: `/Applications/Kanata.app` (binary installed by ansible)
- **LaunchAgent**: `~/Library/LaunchAgents/com.kanata.plist` (installed by ansible)
- **Sudoers**: `/etc/sudoers.d/kanata` - allows passwordless `sudo` for the kanata binary
- **TCP server**: Listens on `127.0.0.1:7070` for layer switching commands

### Hammerspoon Integration

Hammerspoon manages kanata lifecycle and provides a game mode toggle:

- **Auto-toggle**: USB watcher stops kanata when a ZSA keyboard is connected, starts it when disconnected
- **Game mode**: `Cmd+Alt+g` switches to the game layer via TCP and shows "GAME" in the macOS menu bar

## Setup (First Time)

### Prerequisites

Install the Karabiner virtual HID driver:

```bash
brew install --cask karabiner-elements  # provides the VirtualHIDDevice driver
```

> Note: You don't need to run Karabiner-Elements itself - just the driver it installs.

### Enable in Inventory

Add to your machine's inventory file (e.g. `ansible/inventory/Mac.yml`):

```yaml
kanata_enabled: true
```

### Run Ansible

```bash
ma && dotansible kanata --ask-become-pass
```

This will:
1. Install the sudoers entry
2. Download and install the kanata binary into `/Applications/Kanata.app`
3. Install and bootstrap the LaunchAgent

### Grant Input Monitoring Permission

After running ansible, go to:

**System Settings > Privacy & Security > Input Monitoring**

Click `+`, press `Cmd+Shift+G`, type `/Applications/Kanata.app`, click Open.

Kanata will start working immediately and will auto-start on every login.

### Set OS Keyboard to QWERTY

Since kanata handles all remapping, the OS must be set to QWERTY:

**System Settings > Keyboard > Input Sources** - set to "U.S." (standard QWERTY)

## Disabling

Set `kanata_enabled: false` in your inventory and run `dotansible kanata --ask-become-pass`. Ansible will remove the LaunchAgent, app bundle, sudoers entry, and any old LaunchDaemon artifacts.

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

The 240ms tapping term may be too short or too long. Adjust in `~/.config/kanata/config.kbd` - change the two `240` values in each `tap-hold` entry, then run `ma` and restart kanata.

### Game mode not working

Verify the TCP server is running: `echo '{}' | nc -w1 127.0.0.1 7070`. You should get a JSON response with the current layer. If not, check that kanata was started with the `-p 127.0.0.1:7070` flag.
