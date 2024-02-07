# dot-ansible

The installer and updater for [Dotfiles](https://github.com/patrick-motard/dotfiles)

See the [dot-ansible wiki](https://github.com/patrick-motard/dot-ansible/wiki) for documentation and a user guide.

Note: All commands in this page are run from the ansible folder.

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
See `mac.yml` for details on what it does. Comment out any roles or tasks that you don't want to run. For example, if you don't want emacs, comment out the emacs role.

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
