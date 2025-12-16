#!/usr/bin/env zsh
# Homebrew installer functions that automatically sync with Ansible configuration

# Wrapper for brew command that prompts for Ansible sync
function brew() {
  local cmd="$1"
  shift

  case "$cmd" in
    install)
      local is_cask=0
      local package=""

      # Parse arguments to detect --cask and get package name
      while [[ $# -gt 0 ]]; do
        case "$1" in
          --cask)
            is_cask=1
            shift
            ;;
          -*)
            # Skip other flags
            shift
            ;;
          *)
            package="$1"
            break
            ;;
        esac
      done

      if [[ -n "$package" ]]; then
        # Ask user if they want to sync to dotfiles
        echo "Install $([[ $is_cask -eq 1 ]] && echo "cask" || echo "formula"): $package"
        echo -n "Save to dotfiles? [Y/n]: "
        read -r response

        # Default to yes if empty response
        if [[ -z "$response" ]] || [[ "$response" =~ ^[Yy] ]]; then
          if [[ $is_cask -eq 1 ]]; then
            brewci "$package"
          else
            brewi "$package"
          fi
        else
          # Just install without syncing
          if [[ $is_cask -eq 1 ]]; then
            command brew install --cask "$package"
          else
            command brew install "$package"
          fi
        fi
      else
        # No package detected, pass through to brew
        command brew install "$@"
      fi
      ;;

    uninstall)
      local is_cask=0
      local package=""

      # Parse arguments to detect --cask and get package name
      while [[ $# -gt 0 ]]; do
        case "$1" in
          --cask)
            is_cask=1
            shift
            ;;
          -*)
            # Skip other flags
            shift
            ;;
          *)
            package="$1"
            break
            ;;
        esac
      done

      if [[ -n "$package" ]]; then
        # Ask user if they want to sync to dotfiles
        echo "Uninstall $([[ $is_cask -eq 1 ]] && echo "cask" || echo "formula"): $package"
        echo -n "Remove from dotfiles? [Y/n]: "
        read -r response

        # Default to yes if empty response
        if [[ -z "$response" ]] || [[ "$response" =~ ^[Yy] ]]; then
          if [[ $is_cask -eq 1 ]]; then
            brewcu "$package"
          else
            brewu "$package"
          fi
        else
          # Just uninstall without syncing
          if [[ $is_cask -eq 1 ]]; then
            command brew uninstall --cask "$package"
          else
            command brew uninstall "$package"
          fi
        fi
      else
        # No package detected, pass through to brew
        command brew uninstall "$@"
      fi
      ;;

    *)
      # All other brew commands pass through unchanged
      command brew "$cmd" "$@"
      ;;
  esac
}

# Install a formula and update ansible/tasks/homebrew.yml
function brewi() {
  local package="$1"
  local ansible_file="$MOIDIR/ansible/tasks/homebrew.yml"

  if [[ -z "$package" ]]; then
    echo "Usage: brewi <package-name>"
    return 1
  fi

  # Check if package is already in ansible file
  if grep -q "^\s*- $package\s*$" "$ansible_file" 2>/dev/null || grep -q "^\s*- $package\s*#" "$ansible_file" 2>/dev/null; then
    echo "Package '$package' already in Ansible config"
  fi

  # Install the package
  echo "Installing $package..."
  if command brew install "$package"; then
    # Only update ansible if install succeeded and package not already there
    if ! grep -q "^\s*- $package\s*$" "$ansible_file" 2>/dev/null && ! grep -q "^\s*- $package\s*#" "$ansible_file" 2>/dev/null; then
      # Add package to the homebrew formulae section (before "state: present")
      awk -v pkg="      - $package" '
        /^- homebrew:$/ { in_brew = 1 }
        /^    state: present$/ && in_brew && !added {
          print pkg
          added = 1
          in_brew = 0
        }
        { print }
      ' "$ansible_file" > "$ansible_file.tmp" && mv "$ansible_file.tmp" "$ansible_file" || rm -f "$ansible_file.tmp"

      # Sort the package list (using perl for portability - asort requires gawk)
      perl -0777 -pe '
        s/(- homebrew:\n    name:\n)((?:      - .+\n)+)(    state: present)/
          $1 . join("", sort split(\/\n\/, $2)) . "\n" . $3/e
      ' "$ansible_file" > "$ansible_file.tmp" && mv "$ansible_file.tmp" "$ansible_file" || rm -f "$ansible_file.tmp"

      # Commit and push
      git -C "$MOIDIR" add "$ansible_file"
      git -C "$MOIDIR" commit -m "Add homebrew package: $package"
      git -C "$MOIDIR" push

      echo "✓ Added '$package' to Ansible config and pushed changes"
    else
      echo "✓ Installed '$package' (already in Ansible config)"
    fi
  else
    echo "✗ Failed to install '$package' - no changes made to Ansible config"
    return 1
  fi
}

# Install a cask and update ansible/tasks/homebrew.yml
function brewci() {
  local package="$1"
  local ansible_file="$MOIDIR/ansible/tasks/homebrew.yml"

  if [[ -z "$package" ]]; then
    echo "Usage: brewci <cask-name>"
    return 1
  fi

  # Check if package is already in ansible file
  if grep -q "^\s*- $package\s*$" "$ansible_file" 2>/dev/null || grep -q "^\s*- $package\s*#" "$ansible_file" 2>/dev/null; then
    echo "Cask '$package' already in Ansible config"
  fi

  # Install the cask
  echo "Installing cask $package..."
  if command brew install --cask "$package"; then
    # Only update ansible if install succeeded and package not already there
    if ! grep -q "^\s*- $package\s*$" "$ansible_file" 2>/dev/null && ! grep -q "^\s*- $package\s*#" "$ansible_file" 2>/dev/null; then
      # Add package to the homebrew_cask section
      awk -v pkg="      - $package" '
        /^- homebrew_cask:$/ { in_cask = 1 }
        /^    name:$/ && in_cask && !added {
          print
          print pkg
          added = 1
          next
        }
        { print }
      ' "$ansible_file" > "$ansible_file.tmp" && mv "$ansible_file.tmp" "$ansible_file" || rm -f "$ansible_file.tmp"

      # Sort the cask list (using perl for portability - asort requires gawk)
      perl -0777 -pe '
        s/(- homebrew_cask:\n    state: present\n    name:\n)((?:      - .+\n)+)/
          $1 . join("", sort split(\/\n\/, $2)) . "\n"/e
      ' "$ansible_file" > "$ansible_file.tmp" && mv "$ansible_file.tmp" "$ansible_file" || rm -f "$ansible_file.tmp"

      # Commit and push
      git -C "$MOIDIR" add "$ansible_file"
      git -C "$MOIDIR" commit -m "Add homebrew cask: $package"
      git -C "$MOIDIR" push

      echo "✓ Added cask '$package' to Ansible config and pushed changes"
    else
      echo "✓ Installed cask '$package' (already in Ansible config)"
    fi
  else
    echo "✗ Failed to install cask '$package' - no changes made to Ansible config"
    return 1
  fi
}

# Uninstall a formula and update ansible/tasks/homebrew.yml
function brewu() {
  local package="$1"
  local ansible_file="$MOIDIR/ansible/tasks/homebrew.yml"

  if [[ -z "$package" ]]; then
    echo "Usage: brewu <package-name>"
    return 1
  fi

  # Check if package is installed locally
  local is_installed=0
  if command brew list "$package" &>/dev/null; then
    is_installed=1
  fi

  # Check if package is in ansible config
  local in_ansible=0
  if grep -q "^\s*- $package\s*$" "$ansible_file" 2>/dev/null || grep -q "^\s*- $package\s*#" "$ansible_file" 2>/dev/null; then
    in_ansible=1
  fi

  # If not installed locally but in ansible, just remove from ansible
  if [[ $is_installed -eq 0 ]] && [[ $in_ansible -eq 1 ]]; then
    sed -i.tmp "/^\s*- $package\s*$/d; /^\s*- $package\s*#/d" "$ansible_file" && rm -f "$ansible_file.tmp"

    git -C "$MOIDIR" add "$ansible_file"
    git -C "$MOIDIR" commit -m "Remove homebrew package: $package"
    git -C "$MOIDIR" push

    echo "✓ Removed '$package' from Ansible config (was not installed locally)"
    return 0
  fi

  # If not installed and not in ansible, nothing to do
  if [[ $is_installed -eq 0 ]] && [[ $in_ansible -eq 0 ]]; then
    echo "Package '$package' is not installed and not in Ansible config"
    return 1
  fi

  # Create backup before making changes
  cp "$ansible_file" "$ansible_file.backup"

  # Remove from ansible first (we'll restore if uninstall fails)
  local removed=0
  if [[ $in_ansible -eq 1 ]]; then
    sed -i.tmp "/^\s*- $package\s*$/d; /^\s*- $package\s*#/d" "$ansible_file" && rm -f "$ansible_file.tmp"
    removed=1
  fi

  # Uninstall the package
  echo "Uninstalling $package..."
  if command brew uninstall "$package"; then
    if [[ $removed -eq 1 ]]; then
      # Commit and push the removal
      git -C "$MOIDIR" add "$ansible_file"
      git -C "$MOIDIR" commit -m "Remove homebrew package: $package"
      git -C "$MOIDIR" push

      rm -f "$ansible_file.backup"
      echo "✓ Removed '$package' from Ansible config and pushed changes"
    else
      rm -f "$ansible_file.backup"
      echo "✓ Uninstalled '$package' (was not in Ansible config)"
    fi
  else
    # Restore backup if uninstall failed
    if [[ $removed -eq 1 ]]; then
      mv "$ansible_file.backup" "$ansible_file"
      echo "✗ Failed to uninstall '$package' - reverted Ansible config changes"
    else
      rm -f "$ansible_file.backup"
      echo "✗ Failed to uninstall '$package'"
    fi
    return 1
  fi
}

# Uninstall a cask and update ansible/tasks/homebrew.yml
function brewcu() {
  local package="$1"
  local ansible_file="$MOIDIR/ansible/tasks/homebrew.yml"

  if [[ -z "$package" ]]; then
    echo "Usage: brewcu <cask-name>"
    return 1
  fi

  # Check if cask is installed locally
  local is_installed=0
  if command brew list --cask "$package" &>/dev/null; then
    is_installed=1
  fi

  # Check if cask is in ansible config
  local in_ansible=0
  if grep -q "^\s*- $package\s*$" "$ansible_file" 2>/dev/null || grep -q "^\s*- $package\s*#" "$ansible_file" 2>/dev/null; then
    in_ansible=1
  fi

  # If not installed locally but in ansible, just remove from ansible
  if [[ $is_installed -eq 0 ]] && [[ $in_ansible -eq 1 ]]; then
    sed -i.tmp "/^\s*- $package\s*$/d; /^\s*- $package\s*#/d" "$ansible_file" && rm -f "$ansible_file.tmp"

    git -C "$MOIDIR" add "$ansible_file"
    git -C "$MOIDIR" commit -m "Remove homebrew cask: $package"
    git -C "$MOIDIR" push

    echo "✓ Removed cask '$package' from Ansible config (was not installed locally)"
    return 0
  fi

  # If not installed and not in ansible, nothing to do
  if [[ $is_installed -eq 0 ]] && [[ $in_ansible -eq 0 ]]; then
    echo "Cask '$package' is not installed and not in Ansible config"
    return 1
  fi

  # Create backup before making changes
  cp "$ansible_file" "$ansible_file.backup"

  # Remove from ansible first (we'll restore if uninstall fails)
  local removed=0
  if [[ $in_ansible -eq 1 ]]; then
    sed -i.tmp "/^\s*- $package\s*$/d; /^\s*- $package\s*#/d" "$ansible_file" && rm -f "$ansible_file.tmp"
    removed=1
  fi

  # Uninstall the cask
  echo "Uninstalling cask $package..."
  if command brew uninstall --cask "$package"; then
    if [[ $removed -eq 1 ]]; then
      # Commit and push the removal
      git -C "$MOIDIR" add "$ansible_file"
      git -C "$MOIDIR" commit -m "Remove homebrew cask: $package"
      git -C "$MOIDIR" push

      rm -f "$ansible_file.backup"
      echo "✓ Removed cask '$package' from Ansible config and pushed changes"
    else
      rm -f "$ansible_file.backup"
      echo "✓ Uninstalled cask '$package' (was not in Ansible config)"
    fi
  else
    # Restore backup if uninstall failed
    if [[ $removed -eq 1 ]]; then
      mv "$ansible_file.backup" "$ansible_file"
      echo "✗ Failed to uninstall cask '$package' - reverted Ansible config changes"
    else
      rm -f "$ansible_file.backup"
      echo "✗ Failed to uninstall cask '$package'"
    fi
    return 1
  fi
}
