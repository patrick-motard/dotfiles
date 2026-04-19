#!/usr/bin/env zsh
# Silence tmux-which-key status messages after every TPM update.
# build.py emits display-message lines that clutter tmux on every reload.

plugin_dir="$HOME/.tmux/plugins/tmux-which-key"
build_py="$plugin_dir/plugin/build.py"
init_tmux="$plugin_dir/plugin/init.tmux"

[[ -f "$build_py" ]] || exit 0

python3 - "$build_py" <<'PYEOF'
import sys, re
path = sys.argv[1]
with open(path) as f:
    content = f.read()
fixed = re.sub(r"(display -p ['\"])", r"# \1", content)
if fixed != content:
    with open(path, 'w') as f:
        f.write(fixed)
    print("tmux-which-key: silenced display-message lines in build.py")
PYEOF

# Rebuild init.tmux with the silenced build.py
python3 "$build_py" "$plugin_dir/config.yaml" "$init_tmux" 2>/dev/null
