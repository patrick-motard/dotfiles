# Optimize ZSH Startup Time Implementation Plan

## Overview

This plan addresses the slow zsh startup time (currently ~4.8 seconds) with the goal of reducing it to under 200ms. The primary bottlenecks are zplug plugin loading (51.58% of time), unnecessary compinit calls, synchronous SSH agent setup, and various slow-loading completions.

## Current State Analysis

The zsh profiling reveals several major performance issues:
- **zplug operations**: Consuming 217ms (51.58%) with inefficient plugin loading
- **compinit/compaudit**: Running multiple times, taking 85.56ms (20.33%) total
- **SSH agent setup**: Blocking startup with 17.02ms in the Zendesk script
- **Unnecessary sourcing**: Multiple scripts loaded synchronously that could be lazy-loaded
- **Command substitutions**: Several $(command) calls during startup

### Key Discoveries:
- compinit is called at least 3 times (line 5 in .zshrc, line 32 in .zsh/.zshrc, and via zplug)
- SSH keys are added synchronously on every startup
- zplug's cache mechanism isn't being utilized effectively
- nodenv is already lazy-loaded (good pattern to replicate)
- rbenv init runs synchronously on every startup

## Desired End State

A zsh shell that:
- Starts in under 200ms for interactive sessions
- Maintains all current functionality through lazy-loading
- Has no visible degradation in user experience
- Properly caches expensive operations

## What We're NOT Doing

- Removing any existing functionality or tools
- Changing the user's workflow or aliases
- Modifying the fundamental shell architecture
- Removing security features (like SSH agent)

## Implementation Approach

We'll optimize in phases:
1. Fix multiple compinit calls and optimize completion
2. Replace zplug with a faster plugin manager (zinit)
3. Implement lazy-loading for heavy operations
4. Optimize SSH and tool initialization
5. Cache expensive operations

## Phase 1: Fix Completion System

### Overview
Eliminate redundant compinit calls and optimize completion setup.

### Changes Required:

#### 1. Remove duplicate compinit from .zshrc
**File**: `/Users/pmotard/.zshrc`
**Changes**: Remove lines 3-5

```zsh
# Remove these lines:
# fpath=("/Users/pmotard/.oh-my-zsh/custom/completions" $fpath)
# autoload -Uz compinit
# compinit
```

#### 2. Optimize compinit in main zshrc
**File**: `/Users/pmotard/.zsh/.zshrc`
**Changes**: Improve the compinit cache check (lines 27-33)

```zsh
# Optimize compinit by using cache more effectively
autoload -Uz compinit
# Check if dump file exists and is less than 24 hours old
if [[ -f "${ZDOTDIR}/.zcompdump" ]]; then
  # Get file modification time
  if [[ $(date +'%j') != $(stat -f '%Sm' -t '%j' "${ZDOTDIR}/.zcompdump" 2>/dev/null) ]]; then
    compinit
  else
    compinit -C
  fi
else
  compinit
fi
```

### Success Criteria:

#### Automated Verification:
- [ ] No syntax errors: `zsh -n ~/.zsh/.zshrc`
- [ ] Completion still works: `zsh -c 'autoload -Uz compinit; compinit -C; which _git'`

#### Manual Verification:
- [ ] Tab completion works for git, docker, and other commands
- [ ] No error messages during shell startup
- [ ] Measure time improvement: `time zsh -i -c exit`

---

## Phase 2: Replace Zplug with Zinit

### Overview
Zplug is taking over 200ms to load plugins. Zinit is a much faster alternative with better lazy-loading support.

### Changes Required:

#### 1. Install Zinit
**File**: `~/code/scripts/install-zinit.sh` (new)
**Changes**: Create installation script

```bash
#!/usr/bin/env zsh
# Install zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$(dirname $ZINIT_HOME)"
    command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
```

#### 2. Replace Zplug configuration
**File**: `/Users/pmotard/.zsh/.zshrc`
**Changes**: Replace lines 120-144 with zinit configuration

```zsh
#region Zinit (Fast Plugin Manager)
# Load zinit
source "${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git/zinit.zsh"

# Load OMZ libraries first (needed by agnoster theme)
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh

# Agnoster theme with optimizations
DEFAULT_USER=$USER
prompt_context() {}
zinit snippet OMZ::themes/agnoster.zsh-theme

# Vi-mode
zinit snippet OMZ::plugins/vi-mode/vi-mode.plugin.zsh

# Terraform (for tf_prompt_info)
zinit ice as"completion"
zinit snippet OMZ::plugins/terraform/terraform.plugin.zsh

# Autosuggestions (turbo mode for faster startup)
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Syntax highlighting (must be last, turbo mode)
zinit ice wait lucid atinit'zpcompinit; zpcdreplay'
zinit light zsh-users/zsh-syntax-highlighting

#endregion Zinit
```

### Success Criteria:

#### Automated Verification:
- [ ] Zinit installed: `[[ -d "${HOME}/.local/share/zinit/zinit.git" ]]`
- [ ] Plugins load without errors: `zsh -c 'source ~/.zsh/.zshrc 2>&1 | grep -c ERROR'` returns 0

#### Manual Verification:
- [ ] Agnoster theme displays correctly
- [ ] Vi-mode works (pressing ESC enters command mode)
- [ ] Autosuggestions appear when typing
- [ ] Syntax highlighting works

---

## Phase 3: Lazy-load Heavy Operations

### Overview
Move expensive operations to lazy-loading or background execution.

### Changes Required:

#### 1. Lazy-load rbenv
**File**: `/Users/pmotard/.zsh/.zshrc`
**Changes**: Replace lines 53-59 with lazy-loading

```zsh
# Lazy-load rbenv
if [[ -d "$HOME/.rbenv" ]]; then
  export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"

  # Lazy-load rbenv init
  rbenv() {
    unset -f rbenv
    eval "$(command rbenv init - zsh)"
    rbenv "$@"
  }

  # Also lazy-load the Ruby path for neovim
  _rbenv_neovim_path() {
    if command -v rbenv >/dev/null 2>&1; then
      export PATH="$PATH:$(rbenv root)/versions/$(rbenv version-name)/bin"
    fi
  }
  # Only set this when needed (e.g., when opening neovim)
  alias nvim='_rbenv_neovim_path; nvim'
fi
```

#### 2. Background SSH agent setup
**File**: `/Users/pmotard/.local/bin/zendesk_zshrc.sh`
**Changes**: Modify setup_ssh function (lines 3-20) and main call (line 100)

```zsh
# Run SSH setup in background to not block startup
setup_ssh_async() {
    (
        # Ensure agent is running
        ssh-add -l &>/dev/null
        if [[ "$?" == 2 ]]; then
            # Could not open a connection to your authentication agent.
            # Load stored agent connection info.
            [[ -r ~/.ssh-agent ]] && \
                eval "$(<~/.ssh-agent)" >/dev/null
            ssh-add -l &>/dev/null
            if [[ "$?" == 2 ]]; then
                # Start agent and store agent connection info.
                (umask 066; ssh-agent > ~/.ssh-agent)
                eval "$(<~/.ssh-agent)" >/dev/null
            fi
        fi
        # Load identities
        ssh-add -q ~/.ssh/pmotard-github-key 2>/dev/null
    ) &!  # Run in background, disowned
}

# At line 96-100, replace with:
main() {
    setup_ssh_async
}
```

#### 3. Lazy-load heavy completions
**File**: `/Users/pmotard/.zsh/.zshrc`
**Changes**: Lazy-load cicd completion (line 81) and devspace completion (line 121)

```zsh
# Line 81 - Lazy load CICD completion
alias cicd='unalias cicd; source <(cicd completion zsh); cicd'

# In zendesk_zshrc.sh, line 121 - Lazy load devspace
alias devspace='unalias devspace; eval "$(devspace completion zsh)"; devspace'
```

### Success Criteria:

#### Automated Verification:
- [ ] No syntax errors: `zsh -n ~/.zsh/.zshrc && zsh -n ~/.local/bin/zendesk_zshrc.sh`
- [ ] SSH agent starts: `sleep 2 && ssh-add -l` shows keys

#### Manual Verification:
- [ ] rbenv commands work when called
- [ ] SSH operations work after a few seconds
- [ ] Completion works for cicd and devspace when first used

---

## Phase 4: Optimize Tool Initialization

### Overview
Defer or optimize various tool initializations.

### Changes Required:

#### 1. Optimize zoxide initialization
**File**: `/Users/pmotard/.zsh/.zshrc`
**Changes**: Use faster init method (lines 149-152)

```zsh
# Fast zoxide initialization with minimal overhead
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --no-cmd)"
  alias z='__zoxide_z'
  alias zi='__zoxide_zi'
fi
```

#### 2. Lazy-load fzf
**File**: `/Users/pmotard/.zsh/.zshrc`
**Changes**: Defer fzf initialization (lines 154-159)

```zsh
# Lazy-load fzf - only when needed
if command -v fzf >/dev/null 2>&1; then
  _fzf_init() {
    source <(fzf --zsh)
    unset -f _fzf_init
  }
  # Initialize on first use of fzf or Ctrl-R
  alias fzf='_fzf_init; fzf'
  bindkey '^R' '_fzf_init; history-incremental-search-backward'
fi
```

#### 3. Remove duplicate aliases
**File**: `/Users/pmotard/.local/bin/zendesk_zshrc.sh`
**Changes**: Remove duplicate aliases (lines 51-73) that are already in aliases.zsh

### Success Criteria:

#### Automated Verification:
- [ ] zoxide works: `zsh -c 'eval "$(zoxide init zsh --no-cmd)"; type __zoxide_z'`
- [ ] No duplicate alias warnings: `zsh -i -c 'alias' 2>&1 | grep -c "alias.*redefined"` returns 0

#### Manual Verification:
- [ ] zoxide `z` command works
- [ ] fzf functionality works when triggered
- [ ] No visible delays when using these tools

---

## Phase 5: Final Optimizations and Caching

### Overview
Implement final performance improvements and add startup time monitoring.

### Changes Required:

#### 1. Add startup profiling
**File**: `/Users/pmotard/.zsh/.zshrc`
**Changes**: Add optional profiling at the start

```zsh
# Add at the very beginning of the file
# Enable profiling with: PROFILE_STARTUP=true zsh
if [[ "$PROFILE_STARTUP" == true ]]; then
  zmodload zsh/zprof
  # Create timestamp for measuring
  PS4=$'%D{%M%S%.} %N:%i> '
  exec 3>&2 2>"/tmp/zsh_startup_$$.log"
  setopt xtrace prompt_subst
fi

# Add at the very end of the file
if [[ "$PROFILE_STARTUP" == true ]]; then
  unsetopt xtrace
  exec 2>&3 3>&-
  print "Startup log written to /tmp/zsh_startup_$$.log"
  zprof
fi
```

#### 2. Create benchmark script
**File**: `~/code/scripts/zsh-benchmark`
**Changes**: Create new benchmarking utility

```bash
#!/usr/bin/env zsh
# Benchmark zsh startup time

usage="NAME
    zsh-benchmark - Measure zsh startup time

SYNOPSIS
    zsh-benchmark [options]

DESCRIPTION
    Measures zsh startup time and optionally profiles it.

OPTIONS
    -p, --profile    Enable detailed profiling
    -n COUNT        Number of iterations (default: 10)
    -h, --help      Show this help message

EXAMPLES
    zsh-benchmark           # Run 10 iterations
    zsh-benchmark -n 20     # Run 20 iterations
    zsh-benchmark -p        # Run with profiling enabled"

iterations=10
profile=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      echo "$usage"
      exit 0
      ;;
    -p|--profile)
      profile=true
      shift
      ;;
    -n)
      iterations="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

echo "Running $iterations iterations..."
total=0

for i in {1..$iterations}; do
  result=$({ time zsh -i -c exit } 2>&1 | grep total | awk '{print $NF}' | sed 's/s//')
  total=$(echo "$total + $result" | bc)
  echo "  Run $i: ${result}s"
done

average=$(echo "scale=3; $total / $iterations" | bc)
echo ""
echo "Average startup time: ${average}s"

target=0.200
if (( $(echo "$average < $target" | bc -l) )); then
  echo "✓ Target of ${target}s achieved!"
else
  echo "✗ Above target of ${target}s"
fi

if [[ "$profile" == true ]]; then
  echo ""
  echo "Running detailed profile..."
  PROFILE_STARTUP=true zsh -i -c exit
fi
```

### Success Criteria:

#### Automated Verification:
- [ ] Benchmark script works: `~/code/scripts/zsh-benchmark -n 1`
- [ ] Average startup time < 200ms: `~/code/scripts/zsh-benchmark -n 10`

#### Manual Verification:
- [ ] Shell feels snappy and responsive
- [ ] All functionality remains intact
- [ ] No error messages during normal use

---

## Testing Strategy

### Performance Tests:
- Benchmark before and after each phase
- Test on both cold and warm starts
- Verify no regression in functionality

### Functionality Tests:
- Verify all aliases work
- Test git completions
- Confirm theme displays correctly
- Check plugin functionality (vi-mode, autosuggestions, highlighting)

### Manual Testing Steps:
1. Open new terminal - should be fast
2. Test git tab completion: `git ch<TAB>`
3. Test vi mode: press ESC, then navigate with hjkl
4. Test autosuggestions: type a previous command
5. Test lazy-loaded tools: `rbenv version`, `cicd help`
6. Verify SSH: `ssh-add -l` (after 2-3 seconds)

## Performance Considerations

### Expected Improvements:
- **Zinit vs Zplug**: ~150-200ms saved
- **Lazy rbenv**: ~50ms saved
- **Async SSH**: ~17ms saved (non-blocking)
- **Single compinit**: ~60ms saved
- **Lazy completions**: ~30-50ms saved

### Total Expected Improvement:
From ~4800ms to under 200ms (95%+ reduction)

## Migration Notes

1. Backup current configuration before starting
2. Test each phase independently
3. Keep zplug installed initially (can remove after verification)
4. Monitor for any issues over first few days of use

## References

- Current profiling data: `/tmp/zsh-profile.zsh` output
- Zinit documentation: https://github.com/zdharma-continuum/zinit
- ZSH startup optimization guide: https://htr3n.github.io/2018/07/faster-zsh/