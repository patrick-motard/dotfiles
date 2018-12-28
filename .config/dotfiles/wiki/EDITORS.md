# Editors

## Vim

+-----|-----+
| installed | `neovim`(default), `vim` |
+-----|-----+
| alias | `vim`, `nvim` |
+-----|-----+

### Files

+-----|-----+
|`~/.config/nvim/init.vim` | loaded when nvim starts, effectively just reads `~/.vimrc` |
+-----|-----+
| `~/.vimrc` | includes configuration for (n)vim, including plugins, key remaps, etc |
+-----|-----+

### Aliases

+-----|-----+
| leader | `<Space>` |
+-----|-----+
| yank | `<leader> y` |
+-----|-----+
| yank line | `<leader> yy` |
+-----|-----+
| paste | `<leader> p` |
+-----|-----+

### Plugins

For a list of plugins, see `~/.vimrc`. Plugins are managed with `vundle`.

### How copy/paste is shared with OS clipboard

Note: This only works with nvim, not vim.

From `~/.vimrc`

```
set clipboard=unnamedplus

let mapleader=" "
" " Copy to clipboard

vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
```
