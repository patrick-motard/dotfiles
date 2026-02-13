# Tridactyl (Firefox Vim Keybindings)

Vim-style keyboard navigation for Firefox, with Colemak-DH remappings.

## Overview

[Tridactyl](https://github.com/tridactyl/tridactyl) adds Vim-like keybindings to Firefox. Because this setup uses a Colemak-DH keyboard layout, the default hjkl navigation is remapped to **mnei** (same physical positions on Colemak-DH). Displaced keys are relocated to nearby positions.

**Config location**: `~/.config/tridactyl/tridactylrc`

## Setup

1. **Install the extension** from [Firefox Add-ons](https://addons.mozilla.org/en-US/firefox/addon/tridactyl-vim/)

2. **Install the native messenger** — required for Tridactyl to read the local config file. Open Firefox and run:
   ```
   :installnative
   ```
   Without this, Tridactyl can't access the filesystem and won't load your `tridactylrc`.

3. **Load the config** (happens automatically on browser start, or manually):
   ```
   :source
   ```

The native messenger also enables other features like opening an external editor with `Ctrl+i` in text fields.

## Colemak-DH Navigation

The core navigation remapping — `hjkl` becomes `mnei`:

| Key | Action | Replaces |
|-----|--------|----------|
| `m` | Scroll left | `h` |
| `n` | Scroll down | `j` |
| `e` | Scroll up | `k` |
| `i` | Scroll right | `l` |
| `N` | Half-page down | `Ctrl+d` |
| `E` | Half-page up | `Ctrl+u` |
| `M` | Previous tab | — |
| `I` | Next tab | — |

### Displaced Keys

Keys displaced by the navigation remapping are relocated:

| Original | New Key | Action |
|----------|---------|--------|
| `n`/`N` (search next/prev) | `k`/`K` | Find next/previous |
| `i` (focus input) | `l` | Focus input field |
| `m` (mark) | `a` | Add mark |
| `gi` (last input) | `gl` | Focus last input field |

## Quick Reference

### General

| Key | Action |
|-----|--------|
| `o` | Open URL in current tab |
| `O` | Open URL in new tab |
| `B` | Switch tab (buffer list) |
| `f` | Follow link (hint mode) |
| `F` | Follow link in new tab |
| `x` | Close tab |
| `X` | Undo close tab |
| `d` | Scroll half-page down |
| `/` | Start search |
| `?` | Start reverse search |
| `Escape` | Clear search highlighting |

### Tab Management

| Key | Action |
|-----|--------|
| `M` | Previous tab |
| `I` | Next tab |
| `g<` | Move tab left |
| `g>` | Move tab right |
| `gp` | Pin/unpin tab |
| `yd` | Duplicate tab |
| `gd` | Detach tab to new window |
| `g1`–`g9` | Jump to tab by index |

### History

| Key | Action |
|-----|--------|
| `Alt+m` | Back |
| `Alt+i` | Forward |

### Zoom

| Key | Action |
|-----|--------|
| `zi` | Zoom in |
| `zo` | Zoom out |
| `zz` | Reset zoom (100%) |

### Visual/Caret Mode

Enter with `v`. Navigation uses the same `mnei` scheme:

| Key | Action |
|-----|--------|
| `m` | Extend selection left |
| `n` | Extend selection down |
| `e` | Extend selection up |
| `i` | Extend selection right |
| `w` | Extend selection forward by word |
| `b` | Extend selection backward by word |

### Hint Characters

Hint mode uses Colemak-DH home row characters: `arstgmneiowfpluy`

## Ignored Sites

Tridactyl automatically enters ignore mode (passes all keys through) on:

- Gmail (`mail.google.com`)
- Google Docs (`docs.google.com`)
- Google Sheets (`sheets.google.com`)
- Google Slides (`slides.google.com`)

To toggle ignore mode manually: `Shift+Insert` or `:mode ignore`

## Utility

| Key | Action |
|-----|--------|
| `gf` | View page source |
| `;h` | Open help |
| `;r` | Reload config |
| `]]` | Follow "next" link |
| `[[` | Follow "prev" link |
| `;t` | Hint open in new tab |
| `;b` | Hint open in background tab |

## Troubleshooting

**Config not loading on startup**:
- Verify the native messenger is installed: `:native`
- Reinstall if needed: `:installnative`
- Check config path: `:source` should load `~/.config/tridactyl/tridactylrc`

**Keys not working on a site**:
- Some sites (like Google Docs) are in the ignore list — this is intentional
- Firefox's internal pages (`about:*`, `addons.mozilla.org`) block extensions entirely — Tridactyl can't work there

**Native messenger issues on macOS**:
- If `:installnative` fails, ensure Python 3 is available
- Check that `~/.local/share/tridactyl/native_main` exists after install
