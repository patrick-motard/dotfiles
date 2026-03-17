# Firefox Tab & Bookmark Switcher (Hammerspoon)

Fuzzy search open Firefox tabs and bookmarks from Hammerspoon. Jump to any tab or open any bookmark - if a bookmark is already open it switches to that tab instead of opening a new one.

## How It Works

Firefox doesn't expose tabs to external processes directly. This uses the [native messaging API](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging) to bridge the gap:

1. A Firefox extension queries tab data and listens for focus requests
2. A Python native messaging host receives messages from Firefox and exposes a Unix socket
3. Hammerspoon queries the socket, shows results in `hs.chooser`, and sends focus requests back

```
Hammerspoon <-> Unix socket <-> Python host <-> Firefox extension <-> Firefox tabs
```

## Files

All source files live in `~/code/scripts/firefox-tab-search/`:

| File | Purpose |
| --- | --- |
| `extension/manifest.json` | Firefox extension manifest |
| `extension/background.js` | Extension background script - bridges tabs to native host |
| `tab-search-host` | Python native messaging host - runs as a daemon |
| `tab_search_host.json` | Native messaging manifest - tells Firefox where to find the host |
| `firefox-tabs.lua` | Hammerspoon module - hotkey, chooser UI, socket queries |
| `install` | Install script |

The Hammerspoon module is installed to `~/.hammerspoon/src/firefox-tabs.lua` and loaded from `init.lua`.

## Installation

Run the install script once:

```sh
cd ~/code/scripts/firefox-tab-search
./install
```

This:
- Copies the native messaging manifest to `~/Library/Application Support/Mozilla/NativeMessagingHosts/`
- Makes the host executable
- Copies `firefox-tabs.lua` to `~/.hammerspoon/src/`

Then load the Firefox extension manually (required after every Firefox restart):

1. Go to `about:debugging#/runtime/this-firefox`
2. Click **Load Temporary Add-on...**
3. Select `~/code/scripts/firefox-tab-search/extension/manifest.json`

Then reload Hammerspoon (`hyper+m` → `r`).

## Usage

| Hotkey | Action |
| --- | --- |
| `hyper+t` | Fuzzy search open tabs - select to jump to it |
| `hyper+b` | Fuzzy search bookmarks - select to open or switch to it |

Both search by title and URL. Both are also accessible via `hyper+m` → `t` / `b`.

### Bookmark search behavior

If the selected bookmark is already open in any tab, it focuses that tab. If not, it opens it in a new tab. Already-open bookmarks show `open - <url>` in the subtext.

## Persistence Caveat

Firefox only allows unsigned extensions to be loaded as temporary add-ons, which means the extension is cleared on every Firefox restart. You'll need to re-load it via `about:debugging` each time.

To make it permanent, the extension would need to be self-signed - see [Firefox self-signing docs](https://extensionworkshop.com/documentation/publish/signing-and-distribution-overview/).

## Troubleshooting

Check the host log:

```sh
cat ~/.local/share/firefox-tab-search.log
```

If you see `Socket response: None`, the host is running but Firefox isn't connected - reload the extension in `about:debugging`.

If `hyper+t` shows a notification saying the host isn't responding, the Python host isn't running - this shouldn't happen normally as Firefox spawns it, but you can start it manually:

```sh
~/code/scripts/firefox-tab-search/tab-search-host &
```
