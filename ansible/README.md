# dot-ansible

The installer and updater for [Dotfiles](https://github.com/patrick-motard/dotfiles)

See the [dot-ansible wiki](https://github.com/patrick-motard/dot-ansible/wiki) for documentation and a user guide.

Note: All commands in this page are run from the ansible folder.

## Design Decisions

### Performance Goals

**Target: < 10 seconds for typical playbook runs**

The playbook is designed to run frequently (potentially multiple times per day) as part of the dotfile management workflow. To achieve fast execution:

- Updates (brew, git repos) only run at most once per 24 hours
- All operations are idempotent and report accurate changed/unchanged status
- Package managers skip unnecessary update checks when packages are already installed

### Time-Based Update Strategy

Both Homebrew package definitions and git repository updates use a time-based caching mechanism:

- Updates run automatically if more than 24 hours have passed since last update
- If recently updated, updates are skipped for performance
- Can be forced via `force_update=true` variable

**Timestamp Storage:**
- Homebrew: `~/.ansible-last-brew-update`
- Git repos: `~/.ansible-last-git-update`

**Usage:**
```bash
# Normal run (respects 24-hour cache)
ansible-playbook ansible/main.yml

# Force updates regardless of timestamp
ansible-playbook ansible/main.yml -e force_update=true
```

**Rationale:**
This approach balances performance (most runs are fast), freshness (automatic daily updates), and control (can force when needed).

### Idempotency Requirements

All tasks must be truly idempotent and report accurate status:

- Tasks should only report "changed" when they actually modify system state
- Use `changed_when` declarations on shell/command tasks that don't modify state
- Git tasks use time-based updates to avoid unnecessary pulls
- Homebrew tasks use `update_homebrew: no` except in the single update task

### Homebrew Package Management

A single update task runs at the beginning of homebrew operations if needed (time-based check). All subsequent homebrew tasks use `update_homebrew: no` to prevent multiple `brew update` calls which can take 10-30 seconds each.

### Git Repository Management

Git tasks use a time-based approach:
- Check if repo exists and when it was last updated
- If recently updated (< 24 hours), skip pull
- For repos with local changes (e.g., scripts-private), stash/pull/pop with conflict resolution

## Ansible.cfg

Don't modify the `ansible.cfg` file. Setup scripts will copy their host specific `ansible.cfg` file to the root of the ansible folder.

## Setup

Some OS have setup scripts that install required programs. If applicable, run the setup script first one time.

```shell
./mac-setup.sh

# or

./fedora-setup.sh
```

### Commands

Runs the mac playbook that will configure your machine.
See `main.yml` for details on what it does. Comment out any roles or tasks that you don't want to run. For example, if you don't want emacs, comment out the emacs role.

```shell
ansible-playbook main.yml -i inventory/main.yml
```

## Customization

### Create your own settings file

`dot-ansible`'s settings file is an [inventory file](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html). It's just a yaml file with key value pairs in it. Name your hostfile off of your machines hostname, that way you can have one for each of your computers.

To get started, create your own hostfile, using mine as your base:

```shell
cp inventory/h-m-falcon.yml inventory/$(hostname).yml
```

Then edit the inventory file before running ansible.

### Calling `dot-ansible`

```shell
ansible-playbooks main.yml -i ~/code/ansible-playbooks/inventory/$(hostname).yml --ask-become-pass
```

You can alias that command if you'd like. [Here's an example](https://github.com/patrick-motard/dotfiles/blob/master/.zshrc#L155).

```shell
# put this in your ~/.zshrc file
alias update="ansible-playbook ~/code/dot-ansible/main.yml -i ~/code/dot-ansible/inventory/$(hostname).yml --ask-become-pass"
```

## Testing Changes

When modifying the playbook:

1. **Test the fast path**: Run twice in succession - second run should be < 10 seconds
2. **Test idempotency**: Verify no tasks report "changed" on second run
3. **Test force update**: Run with `-e force_update=true` to verify update logic
4. **Profile performance**: Use `ANSIBLE_CALLBACK_WHITELIST=profile_tasks` for timing data

Example:
```bash
# Profile the playbook
ANSIBLE_CALLBACK_WHITELIST=profile_tasks ansible-playbook ansible/main.yml

# Verify idempotency
ansible-playbook ansible/main.yml
ansible-playbook ansible/main.yml  # Should be fast, no changes
```
