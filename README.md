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
<!-- WARN: Git information should not be in a public repo -->
- [i3](#i3)
- [kitty](https://sw.kovidgoyal.net/kitty/)
- [polybar](#polybar)
- [rofi](#rofi)
- picom
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

## Additional software

- eza (instead of ls)
- zoxide (instead of cd)
- python3

## TODOS

- Enable proper screenshot functionality
- Add cc to nix
