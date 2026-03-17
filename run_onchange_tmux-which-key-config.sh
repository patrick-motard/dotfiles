#!/usr/bin/env zsh
# Deploy tmux-which-key config to the plugin directory whenever the config changes.
# chezmoi runs this script when its hash changes (onchange).
#
# Source config hash: {{ include "dot_config/tmux/plugins/tmux-which-key/config.yaml" | sha256sum }}

plugin_dir="$HOME/.tmux/plugins/tmux-which-key"
config_src="$HOME/.config/tmux/plugins/tmux-which-key/config.yaml"

if [[ ! -d "$plugin_dir" ]]; then
  echo "tmux-which-key plugin not installed, skipping config deploy"
  exit 0
fi

cp "$config_src" "$plugin_dir/config.yaml"
echo "Deployed tmux-which-key config to $plugin_dir/config.yaml"

# Rebuild the init.tmux from the new config
if command -v python3 &>/dev/null && [[ -f "$plugin_dir/plugin/build.py" ]]; then
  python3 "$plugin_dir/plugin/build.py" "$plugin_dir/config.yaml" "$plugin_dir/plugin/init.tmux" \
    && echo "Rebuilt tmux-which-key init.tmux"
fi
