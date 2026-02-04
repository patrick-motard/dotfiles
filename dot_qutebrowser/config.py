# Qutebrowser config with Colemak-DH keybindings
# Navigation: mnei (m=left, n=down, e=up, i=right)

# Unbind defaults that conflict with Colemak-DH navigation
config.unbind('m')  # was: quickmark-save
config.unbind('n')  # was: search-next
config.unbind('i')  # was: enter-mode insert
config.unbind('N')  # was: search-prev

# =============================================================================
# COLEMAK-DH NAVIGATION (mnei = hjkl)
# =============================================================================

# Basic scrolling (hjkl -> mnei)
config.bind('m', 'scroll left')
config.bind('n', 'scroll down')
config.bind('e', 'scroll up')
config.bind('i', 'scroll right')

# Tab navigation (JK -> NE for prev/next)
config.bind('N', 'tab-prev')
config.bind('E', 'tab-next')

# History navigation (HL -> MI)
config.bind('M', 'back')
config.bind('I', 'forward')

# =============================================================================
# RELOCATED BINDINGS (displaced by navigation)
# =============================================================================

# Search next/prev (n/N -> k/K)
config.bind('k', 'search-next')
config.bind('K', 'search-prev')

# Insert mode (i -> l)
config.bind('l', 'mode-enter insert')

# Quickmarks (m -> a for "add")
config.bind('a', 'quickmark-save')

# =============================================================================
# HINT MODE COLEMAK-DH
# =============================================================================

# Use Colemak-DH home row for hint characters
c.hints.chars = 'arstgmneiowfpluy'

# =============================================================================
# GO COMMANDS (g prefix) - remap where needed
# =============================================================================

config.unbind('gm')  # was: tab-move
config.unbind('gi')  # was: hint inputs

# Tab movement
config.bind('ga', 'tab-move')  # relocated from gm

# Focus input (gi -> gl)
config.bind('gl', 'hint inputs')

# =============================================================================
# WINDOW/SPLIT NAVIGATION (if using splits)
# =============================================================================

# ctrl+w prefix follows same mnei pattern
config.bind('<Ctrl-w>m', 'tab-focus last')
config.bind('<Ctrl-w>n', 'tab-next')
config.bind('<Ctrl-w>e', 'tab-prev')
config.bind('<Ctrl-w>i', 'tab-focus last')

# =============================================================================
# VISUAL/CARET MODE
# =============================================================================

config.bind('m', 'move-to-prev-char', mode='caret')
config.bind('n', 'move-to-next-line', mode='caret')
config.bind('e', 'move-to-prev-line', mode='caret')
config.bind('i', 'move-to-next-char', mode='caret')

config.bind('M', 'move-to-start-of-line', mode='caret')
config.bind('I', 'move-to-end-of-line', mode='caret')

# Word movement in caret mode
config.bind('w', 'move-to-next-word', mode='caret')
config.bind('b', 'move-to-prev-word', mode='caret')

# Search in caret mode
config.bind('k', 'search-next', mode='caret')
config.bind('K', 'search-prev', mode='caret')

# =============================================================================
# COMMAND MODE
# =============================================================================

config.bind('<Ctrl-n>', 'completion-item-focus next', mode='command')
config.bind('<Ctrl-e>', 'completion-item-focus prev', mode='command')

# =============================================================================
# OPTIONAL: Open in external browser (for Okta, etc.)
# =============================================================================

config.bind(',o', 'spawn open -a Firefox {url}')
config.bind(',O', 'spawn open -a "Google Chrome" {url}')

# =============================================================================
# HELP
# =============================================================================

# Focus bindings tab if open, otherwise open it
config.bind('?', 'spawn --userscript focus-or-open qute://bindings', mode='normal')

# =============================================================================
# AD BLOCKING
# =============================================================================

c.content.blocking.method = 'both'
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt",
]
