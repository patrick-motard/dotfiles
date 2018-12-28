# Q&A

**Where should I set my $PATH?**
`~/.profile**

**Where should I set environment variables?**
Sensitive variables: `~/.zshenv` (do not check this into your repo**

**Where is Xserver (startx) started?**
In `~/.zprofile**.

**Where is i3 started?**
In `~/.xinit**

**How do I update my pacman and AUR packages?**
Run the `update` alias in your terminal. This runs `~/.local/bin/setup/update**.

**How can I see what an alias is doing?**
`alias {name of alias}`
```
alias update
update='bash ~/.local/bin/setup/update'
```

**Where are dotfiles shell scripts located?**
`~/.local/bin/setup/install**

**How do I update golang and it's packages?**
In terminal: `update_golang**

**How do I update my pacman mirrorlist?**
Relvant ['pacman: mirror list out of date #92'](https://github.com/patrick-motard/dotfiles/issues/92)
In terminal: `update_pacman_mirrorlist`

