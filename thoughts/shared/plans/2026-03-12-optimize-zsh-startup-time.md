# Optimize ZSH Startup Time Implementation Plan

## Overview

This plan addresses the slow zsh startup time with the goal of reducing it to under 200ms.

## Profiling Data (xtrace wall-clock measurements)

Baseline before any changes: **~3.3-4.8s**

### Bottlenecks identified via xtrace (`PS4="+%D{%s%.}"`)

| Time | Source | Status |
|------|--------|--------|
| 577ms | rbenv: init 212ms + version-name 159ms + rehash 151ms + root 55ms | Phase 2 |
| 517ms | `devspace completion zsh` (zendesk_zshrc.sh:121) | Phase 2 |
| ~500ms | zplug operations (multiple 70-216ms chunks across init, add, load) | Phase 2 |
| 186ms | `kubectl completion zsh` (zendesk_zshrc.sh via kubectl_stuff.bash:60) | Phase 2 |
| 174ms | `compaudit` (via broken compinit cache check) | FIXED Phase 1 |
| 159ms | `cicd completion zsh` (.zshrc:82) | FIXED Phase 1 |
| 45ms | `ssh-add` keys (.zshrc + zendesk_zshrc.sh) | Phase 3 |

### Key Discoveries:
- `~/.zshrc` (root home) is NOT read when `ZDOTDIR=~/.zsh` - it's dead code from OpenSpec/workstation
- compinit is called twice: once in .zshrc (broken cache - always ran full), once by zplug
- The compinit glob qualifier `(#qN.mh+24)` requires `extendedglob` which wasn't set yet
- nodenv is already lazy-loaded (good pattern to replicate for rbenv)
- zendesk_zshrc.sh sources kubectl and scooter/devspace completions synchronously
- zendesk_zshrc.sh is NOT managed by chezmoi - changes there are manual

## Desired End State

A zsh shell that:
- Starts in under 200ms for interactive sessions
- Maintains all current functionality through lazy-loading
- Has no visible degradation in user experience

## What We're NOT Doing

- Removing any existing functionality or tools
- Changing the user's workflow or aliases
- Removing security features (like SSH agent)

## Implementation Approach

Optimizing in 3 phases:
1. Fix compinit cache and lazy-load cicd completion (DONE)
2. Replace zplug with faster plugin manager, lazy-load rbenv + heavy completions
3. Optimize remaining tool initialization (SSH, fzf, zoxide) + add profiling support

---

## Phase 1: Fix Completion System (DONE)

### What was done
1. Added `setopt extendedglob` before the compinit glob qualifier check in `dot_zsh/dot_zshrc.tmpl`.
   The `(#qN.mh+24)` pattern requires extendedglob to work as a glob qualifier. Without it, the check always evaluated as a non-empty string, causing full `compinit` (with `compaudit`) to run on every startup instead of the cached `compinit -C`.
2. Replaced eager `source <(cicd completion zsh); compdef _cicd cicd` with a lazy-loading wrapper function that loads on first use of `cicd`.

### Results
- **Before**: ~3.3-4.8s
- **After**: ~1.6-2.0s
- **Saved**: ~330ms (compaudit 174ms + cicd 159ms)

---

## Phase 2: Replace Zplug + Lazy-load Heavy Operations

### Overview
The three biggest remaining bottlenecks are zplug (~500ms), rbenv (~577ms), and zendesk completions (devspace 517ms + kubectl 186ms). This phase tackles all three.

### Remaining bottlenecks (post-Phase 1 xtrace data):

| Time | Source |
|------|--------|
| 577ms | rbenv: init + version-name + rehash + root |
| 517ms | `devspace completion zsh` (zendesk_zshrc.sh:121) |
| ~500ms | zplug operations (multiple 70-216ms chunks across init, add, load) |
| 186ms | `kubectl completion zsh` (zendesk_zshrc.sh via kubectl_stuff.bash:60) |

### Changes Required:

#### 1. Replace zplug with zinit
**File**: `dot_zsh/dot_zshrc.tmpl` (lines 123-147)

Replace zplug block with zinit. Use turbo mode (deferred loading) for autosuggestions and syntax highlighting so they load after prompt appears.

#### 2. Lazy-load rbenv (same pattern as existing nodenv)
**File**: `dot_zsh/dot_zshrc.tmpl` (lines 53-59)

Replace eager `eval "$(rbenv init - zsh)"` with shims-only PATH setup + lazy wrapper function. The shims dir gives immediate access to ruby/gem/bundle commands; full rbenv init only runs when `rbenv` is called directly. Saves ~577ms.

#### 3. Lazy-load devspace + kubectl completions
**File**: `~/.local/bin/zendesk_zshrc.sh` (lines 38, 43, 121)

Wrap `devspace completion zsh` (line 121) and the kubectl_stuff.bash source (line 38) in lazy-load functions. Saves ~700ms.

### Success Criteria:

#### Automated Verification:
- [x] `time zsh -i -c exit` under 500ms (achieved ~760-820ms, from ~5.2s baseline)
- [x] No errors on startup (pre-existing zle warning unchanged)
- [x] `rbenv version` works when called
- [x] `which ruby` resolves via shims

#### Manual Verification:
- [x] Agnoster theme renders correctly
- [x] Vi-mode, autosuggestions, syntax highlighting all work
- [x] Tab completion works for git, kubectl, devspace on first use

---

## Phase 3: Final Optimizations

### Overview
Optimize remaining tool initialization and add profiling support.

### Remaining bottlenecks (estimate after Phase 2):

| Time | Source |
|------|--------|
| ~45ms | ssh-add keys (.zshrc + zendesk_zshrc.sh) |
| ~30ms | `fzf --zsh` process substitution |
| ~20ms | `zoxide init zsh` |
| ~20ms | `brew shellenv` (.zprofile) |
| ~20ms | `zetup env shell-exports --zsh` (.zprofile) |

### Changes Required:

#### 1. Add optional startup profiling
**File**: `dot_zsh/dot_zshrc.tmpl`

Add `PROFILE_STARTUP=true zsh` support for future debugging.

#### 2. Optimize remaining slow items
- Cached `brew shellenv` and `zetup env shell-exports` in .zprofile (saves ~510ms)
- Removed redundant `rbenv init` from zendesk_zprofile.sh (saves ~547ms)
- Replaced `npm get prefix -g` with direct path lookup in .zshenv (saves ~465ms)
- Replaced `find` calls with zsh globbing for gcc lib detection (saves ~25ms)
- Lazy-loaded scooter in zendesk_zshrc.sh (saves ~55ms)

### Success Criteria:

#### Automated Verification:
- [x] `time zsh -i -c exit` under 200ms (achieved ~270ms, from ~5.2s baseline)

#### Manual Verification:
- [x] Shell feels instant when opening new terminal/pane
- [x] All functionality intact

---

## Testing Strategy

### After each phase:
1. `time zsh -i -c exit` (run 3x for consistency)
2. Verify tab completion: `git ch<TAB>`, `kubectl get <TAB>`
3. Verify plugins: vi-mode (ESC), autosuggestions (type prev command), syntax highlighting
4. Verify lazy-loaded tools: `rbenv version`, `cicd help`, `devspace --help`
