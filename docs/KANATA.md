# Kanata - Keyboard Remapping

Kanata provides a full Colemak-DH matrix layout with homerow mods, managed as a macOS system service.

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

Uses `tap-hold-release-keys` so fast typing doesn't trigger modifiers.

## Architecture

### Why an App Bundle?

macOS requires Input Monitoring permission for any process that intercepts keystrokes. This permission can only be granted to `.app` bundles, not raw CLI binaries. The workaround:

1. A minimal app bundle lives at `/Applications/Kanata.app`
2. The bundle's executable is a shell script that runs `sudo kanata`
3. macOS shows `Kanata.app` in Privacy & Security > Input Monitoring
4. A system LaunchDaemon launches the app bundle at boot

### Components

- **Config**: `~/.config/kanata/config.kbd` (managed by chezmoi)
- **Plist source**: `~/.config/kanata/com.kanata.plist` (copied by ansible)
- **App bundle**: `/Applications/Kanata.app` (created by ansible)
- **LaunchDaemon**: `/Library/LaunchDaemons/com.kanata.plist` (installed by ansible)
- **Sudoers**: `/etc/sudoers.d/kanata` - allows passwordless `sudo kanata`

## Setup (First Time)

### Prerequisites

Install kanata and the Karabiner virtual HID driver:

```bash
brew install kanata
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
2. Create `/Applications/Kanata.app`
3. Install and bootstrap the LaunchDaemon

### Grant Input Monitoring Permission

After running ansible, go to:

**System Settings > Privacy & Security > Input Monitoring**

Click `+`, press `Cmd+Shift+G`, type `/Applications/Kanata.app`, click Open.

Kanata will start working immediately and will auto-start on every reboot.

### Set OS Keyboard to QWERTY

Since kanata handles all remapping, the OS must be set to QWERTY:

**System Settings > Keyboard > Input Sources** - set to "U.S." (standard QWERTY)

## Disabling

Set `kanata_enabled: false` in your inventory and run `dotansible kanata --ask-become-pass`. Ansible will remove the LaunchDaemon, app bundle, and sudoers entry.

## Troubleshooting

### Check logs

```bash
tail -f /tmp/kanata.log
```

### Manually restart

```bash
sudo launchctl bootout system/com.kanata 2>/dev/null; sudo launchctl bootstrap system /Library/LaunchDaemons/com.kanata.plist
```

### `IOHIDDeviceOpen error: not permitted Apple Internal Keyboard`

This error is **expected and harmless**. Kanata uses the Karabiner virtual HID driver rather than direct HID access. As long as you see `driver connected: true` and `Starting kanata proper`, it's working.

### Keys not remapping after reboot

Check that `Kanata.app` is still in Input Monitoring. macOS occasionally removes permissions after system updates - re-add it if needed.

### Homerow mods triggering accidentally

The 240ms tapping term may be too short or too long. Adjust in `~/.config/kanata/config.kbd` - change the two `240` values in each `tap-hold-release-keys` entry, then run `ma` and restart kanata.
