{ pkgs, lib, ... }: {
  home.username = "ceedrich";
  home.homeDirectory = "/home/ceedrich";

  catppuccin.zsh-syntax-highlighting.enable = false;

  home.stateVersion = "24.11";
}
