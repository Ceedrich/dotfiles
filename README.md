# Dotfiles

<!-- TODO: work with git submodules -->

## Instalation

Clone this repo into `~` and then `cd` into the directory and run

```sh
stow <package>
```

where `<package>` is the package you want to install

## Dependencies

### Font

Many of the packages depend on the `JetBrainsMono NerdFont`.
Install on [nerdfonts.com](https://nerdfonts.com) or via pacman:

```sh
sudo pacman -S ttf-jetbrains-mono-nerd
```

## Packages

List of all packages:

- [alacritty](https://alacritty.org/) (deprecated, use kitty instead)
- [bat](https://github.com/sharkdp/bat)
<!-- WARN: Git information should not be in a public repo -->
- git
- [i3](#i3)
- [kitty](https://sw.kovidgoyal.net/kitty/)
- [polybar](#polybar)
- [rofi](#rofi)
- starship
- [tmux](#tmux)
- [zsh](#zsh)
- picom
- profile
- [yazi](https://yazi-rs.github.io/) <!-- TODO: add configuration -->

Dependencies:

- feh

### i3

If picom is not working, remove the --experimental-backends flag from i3 config

### polybar

Dependencies:

- xrandr (xorg-xrandr)

<!-- TODO: add more information -->

In order to use "polybar" certain settings such as batteries and network adapters need to be configured

### rofi

This rofi config is a bit unstable and not guaranteed to work across systems.

### tmux

To finalize the tmux instalation, install [tpm](https://github.com/tmux-plugins/tpm):

```sh
git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/tmux/plugins/tpm
```

Then, in tmux press `<leader>r` to reload the tmux configuration and `<leader>I` to install plugins

### zsh

<!-- TODO: This can't be that hard!!! -->

To configure zsh, create a zshenv file in `/etc/zsh/` containing the following lines:

```sh
if [[ -z "$PATH" || "$PATH" == "/bin:/usr/bin" ]]; then
	export PATH="/usr/local/bin:/usr/bin:/bin:/usr/games"
fi

if [[ -z "$XDG_CONFIG_HOME" ]]; then
	export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -d "$XDG_CONFIG_HOME" ]]; then
	export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
```

Dependencies:

- bat
- [delta](https://github.com/dandavison/delta)

## Additional software

- eza (instead of ls)
- zoxide (instead of cd)
- python3

## TODOS

- Enable proper screenshot functionality
