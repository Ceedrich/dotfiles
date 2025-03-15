{ lib, ... }: {
  imports = [
    ./hyprland
    ./git
    ./neovim
    ./shell
  ];

  zsh.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
}
