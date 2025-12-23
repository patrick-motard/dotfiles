#!/usr/bin/env zsh
# Homebrew installer functions that automatically sync with Ansible configuration

# Helper function to check if a package exists in the homebrew formulae section
function _brew_package_in_yaml() {
  local package="$1"
  local ansible_file="${2:-$MOIDIR/ansible/tasks/homebrew.yml}"
  yq eval "[.[] | select(has(\"homebrew\")) | .homebrew.name[]] | contains([\"$package\"])" "$ansible_file" 2>/dev/null | grep -q "true"
}

# Helper function to check if a cask exists in the homebrew_cask section
function _brew_cask_in_yaml() {
  local package="$1"
  local ansible_file="${2:-$MOIDIR/ansible/tasks/homebrew.yml}"
  yq eval "[.[] | select(has(\"homebrew_cask\")) | .homebrew_cask.name[]] | contains([\"$package\"])" "$ansible_file" 2>/dev/null | grep -q "true"
}

# Helper function to check if a tap exists in the homebrew_tap section
function _brew_tap_in_yaml() {
  local tap_name="$1"
  local ansible_file="${2:-$MOIDIR/ansible/tasks/homebrew.yml}"
  yq eval "[.[] | select(has(\"homebrew_tap\")) | .homebrew_tap.name[]] | contains([\"$tap_name\"])" "$ansible_file" 2>/dev/null | grep -q "true"
}

# Helper function to remove a package from YAML (checks both formula and cask sections)
function _brew_remove_from_yaml() {
  local package="$1"
  local ansible_file="${2:-$MOIDIR/ansible/tasks/homebrew.yml}"

  # Remove from homebrew formulae section
  yq eval "(.[] | select(has(\"homebrew\")) | .homebrew.name) |= (. - [\"$package\"])" -i "$ansible_file" 2>/dev/null

  # Remove from homebrew_cask section
  yq eval "(.[] | select(has(\"homebrew_cask\")) | .homebrew_cask.name) |= (. - [\"$package\"])" -i "$ansible_file" 2>/dev/null
}

# Helper function to remove a tap from YAML
function _brew_remove_tap_from_yaml() {
  local tap_name="$1"
  local ansible_file="${2:-$MOIDIR/ansible/tasks/homebrew.yml}"

  yq eval "(.[] | select(has(\"homebrew_tap\")) | .homebrew_tap.name) |= (. - [\"$tap_name\"])" -i "$ansible_file" 2>/dev/null
}

# Wrapper for brew command that prompts for Ansible sync
function brew() {
  local cmd="$1"
  shift

  case "$cmd" in
    install)
      local is_cask=0
      local package=""
      local has_cask_flag=0

      # Parse arguments to detect --cask and get package name
      while [[ $# -gt 0 ]]; do
        case "$1" in
          --cask)
            is_cask=1
            has_cask_flag=1
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
        # If --cask not specified, check if package is a cask by querying brew info
        if [[ $has_cask_flag -eq 0 ]]; then
          if brew info --cask "$package" &>/dev/null; then
            is_cask=1
          fi
        fi

        # Ask user if they want to sync to dotfiles
        if [[ $is_cask -eq 1 ]]; then
          echo "Install cask: $package"
        else
          echo "Install formula: $package"
        fi
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
      local ansible_file="$MOIDIR/ansible/tasks/homebrew.yml"

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
        # Detect if package is actually installed as a cask (if --cask not specified)
        if [[ $is_cask -eq 0 ]]; then
          if command brew list --cask "$package" &>/dev/null; then
            is_cask=1
          # If not installed, check YAML to determine if it's a cask or formula
          elif ! command brew list "$package" &>/dev/null; then
            # Check if it's in the homebrew_cask section using yq
            if _brew_cask_in_yaml "$package" "$ansible_file"; then
              is_cask=1
            fi
          fi
        fi

        # Ask user if they want to sync to dotfiles
        if [[ $is_cask -eq 1 ]]; then
          echo "Uninstall cask: $package"
        else
          echo "Uninstall formula: $package"
        fi
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

    tap)
      local tap_name="$1"

      if [[ -n "$tap_name" ]]; then
        echo "Tap: $tap_name"
        echo -n "Save to dotfiles? [Y/n]: "
        read -r response

        if [[ -z "$response" ]] || [[ "$response" =~ ^[Yy] ]]; then
          brewtap "$tap_name"
        else
          command brew tap "$tap_name"
        fi
      else
        # No tap specified, pass through (lists taps)
        command brew tap "$@"
      fi
      ;;

    untap)
      local tap_name="$1"

      if [[ -n "$tap_name" ]]; then
        echo "Untap: $tap_name"
        echo -n "Remove from dotfiles? [Y/n]: "
        read -r response

        if [[ -z "$response" ]] || [[ "$response" =~ ^[Yy] ]]; then
          brewuntap "$tap_name"
        else
          command brew untap "$tap_name"
        fi
      else
        command brew untap "$@"
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
  if _brew_package_in_yaml "$package" "$ansible_file"; then
    echo "Package '$package' already in Ansible config"
  fi

  # Install the package
  echo "Installing $package..."
  if command brew install "$package"; then
    # Only update ansible if install succeeded and package not already there
    if ! _brew_package_in_yaml "$package" "$ansible_file"; then
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

      # Update hash cache with new file state
      shasum "$ansible_file" | awk '{print $1}' > "$MOIDIR/ansible/.homebrew-hash"

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
  if _brew_cask_in_yaml "$package" "$ansible_file"; then
    echo "Cask '$package' already in Ansible config"
  fi

  # Install the cask
  echo "Installing cask $package..."
  if command brew install --cask "$package"; then
    # Only update ansible if install succeeded and package not already there
    if ! _brew_cask_in_yaml "$package" "$ansible_file"; then
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

      # Update hash cache with new file state
      shasum "$ansible_file" | awk '{print $1}' > "$MOIDIR/ansible/.homebrew-hash"

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

  # Check if package is in ansible config (check both sections in case it was miscategorized)
  local in_ansible=0
  local in_cask_section=0
  if _brew_package_in_yaml "$package" "$ansible_file"; then
    in_ansible=1
  fi
  if _brew_cask_in_yaml "$package" "$ansible_file"; then
    in_ansible=1
    in_cask_section=1
  fi

  # If not installed locally but in ansible, just remove from ansible
  if [[ $is_installed -eq 0 ]] && [[ $in_ansible -eq 1 ]]; then
    echo "Package '$package' is not installed, removing from Ansible config..."
    _brew_remove_from_yaml "$package" "$ansible_file"

    git -C "$MOIDIR" add "$ansible_file"
    git -C "$MOIDIR" commit -m "Remove homebrew package: $package"
    git -C "$MOIDIR" push

    # Update hash cache with new file state
    shasum "$ansible_file" | awk '{print $1}' > "$MOIDIR/ansible/.homebrew-hash"

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
    _brew_remove_from_yaml "$package" "$ansible_file"
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

      # Update hash cache with new file state
      shasum "$ansible_file" | awk '{print $1}' > "$MOIDIR/ansible/.homebrew-hash"

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

  # Check if cask is in ansible config (check both sections in case it was miscategorized)
  local in_ansible=0
  local in_formula_section=0
  if _brew_cask_in_yaml "$package" "$ansible_file"; then
    in_ansible=1
  fi
  if _brew_package_in_yaml "$package" "$ansible_file"; then
    in_ansible=1
    in_formula_section=1
  fi

  # If not installed locally but in ansible, just remove from ansible
  if [[ $is_installed -eq 0 ]] && [[ $in_ansible -eq 1 ]]; then
    echo "Cask '$package' is not installed, removing from Ansible config..."
    _brew_remove_from_yaml "$package" "$ansible_file"

    git -C "$MOIDIR" add "$ansible_file"
    git -C "$MOIDIR" commit -m "Remove homebrew cask: $package"
    git -C "$MOIDIR" push

    # Update hash cache with new file state
    shasum "$ansible_file" | awk '{print $1}' > "$MOIDIR/ansible/.homebrew-hash"

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
    _brew_remove_from_yaml "$package" "$ansible_file"
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

      # Update hash cache with new file state
      shasum "$ansible_file" | awk '{print $1}' > "$MOIDIR/ansible/.homebrew-hash"

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

# Add a tap and update ansible/tasks/homebrew.yml
function brewtap() {
  local tap_name="$1"
  local ansible_file="$MOIDIR/ansible/tasks/homebrew.yml"

  if [[ -z "$tap_name" ]]; then
    echo "Usage: brewtap <tap-name>"
    return 1
  fi

  # Check if tap is already in ansible file
  if _brew_tap_in_yaml "$tap_name" "$ansible_file"; then
    echo "Tap '$tap_name' already in Ansible config"
  fi

  # Add the tap
  echo "Tapping $tap_name..."
  if command brew tap "$tap_name"; then
    # Only update ansible if tap succeeded and not already there
    if ! _brew_tap_in_yaml "$tap_name" "$ansible_file"; then
      # Add tap to the homebrew_tap section (before "state: present")
      awk -v tap="      - $tap_name" '
        /^- name: Add Homebrew taps$/ { in_tap = 1 }
        /^    state: present$/ && in_tap && !added {
          print tap
          added = 1
          in_tap = 0
        }
        { print }
      ' "$ansible_file" > "$ansible_file.tmp" && mv "$ansible_file.tmp" "$ansible_file" || rm -f "$ansible_file.tmp"

      # Sort the tap list
      perl -0777 -pe '
        s/(- name: Add Homebrew taps\n  homebrew_tap:\n    name:\n)((?:      - .+\n)+)(    state: present)/
          $1 . join("", sort split(\/\n\/, $2)) . "\n" . $3/e
      ' "$ansible_file" > "$ansible_file.tmp" && mv "$ansible_file.tmp" "$ansible_file" || rm -f "$ansible_file.tmp"

      # Commit and push
      git -C "$MOIDIR" add "$ansible_file"
      git -C "$MOIDIR" commit -m "Add homebrew tap: $tap_name"
      git -C "$MOIDIR" push

      # Update hash cache with new file state
      shasum "$ansible_file" | awk '{print $1}' > "$MOIDIR/ansible/.homebrew-hash"

      echo "Added '$tap_name' to Ansible config and pushed changes"
    else
      echo "Tapped '$tap_name' (already in Ansible config)"
    fi
  else
    echo "Failed to tap '$tap_name' - no changes made to Ansible config"
    return 1
  fi
}

# Remove a tap and update ansible/tasks/homebrew.yml
function brewuntap() {
  local tap_name="$1"
  local ansible_file="$MOIDIR/ansible/tasks/homebrew.yml"

  if [[ -z "$tap_name" ]]; then
    echo "Usage: brewuntap <tap-name>"
    return 1
  fi

  # Check if tap is currently tapped
  local is_tapped=0
  if command brew tap | grep -q "^$tap_name$"; then
    is_tapped=1
  fi

  # Check if tap is in ansible config
  local in_ansible=0
  if _brew_tap_in_yaml "$tap_name" "$ansible_file"; then
    in_ansible=1
  fi

  # If not tapped but in ansible, just remove from ansible
  if [[ $is_tapped -eq 0 ]] && [[ $in_ansible -eq 1 ]]; then
    _brew_remove_tap_from_yaml "$tap_name" "$ansible_file"

    git -C "$MOIDIR" add "$ansible_file"
    git -C "$MOIDIR" commit -m "Remove homebrew tap: $tap_name"
    git -C "$MOIDIR" push

    # Update hash cache with new file state
    shasum "$ansible_file" | awk '{print $1}' > "$MOIDIR/ansible/.homebrew-hash"

    echo "Removed '$tap_name' from Ansible config (was not tapped locally)"
    return 0
  fi

  # If not tapped and not in ansible, nothing to do
  if [[ $is_tapped -eq 0 ]] && [[ $in_ansible -eq 0 ]]; then
    echo "Tap '$tap_name' is not tapped and not in Ansible config"
    return 1
  fi

  # Untap if currently tapped
  if [[ $is_tapped -eq 1 ]]; then
    echo "Untapping $tap_name..."
    if ! command brew untap "$tap_name"; then
      echo "Failed to untap '$tap_name'"
      return 1
    fi
  fi

  # Remove from ansible if present
  if [[ $in_ansible -eq 1 ]]; then
    _brew_remove_tap_from_yaml "$tap_name" "$ansible_file"

    git -C "$MOIDIR" add "$ansible_file"
    git -C "$MOIDIR" commit -m "Remove homebrew tap: $tap_name"
    git -C "$MOIDIR" push

    # Update hash cache with new file state
    shasum "$ansible_file" | awk '{print $1}' > "$MOIDIR/ansible/.homebrew-hash"

    echo "Removed '$tap_name' from Ansible config and pushed changes"
  else
    echo "Untapped '$tap_name' (was not in Ansible config)"
  fi
}
