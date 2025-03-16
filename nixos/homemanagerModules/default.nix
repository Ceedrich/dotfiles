{ lib, ... }: {
  imports = [
    ./hyprland
    ./git
    ./neovim
    ./shell
    ./terminal
    ./spotify
    ./btop
    ./yazi
    ./tmux
  ];

  catppuccin.flavor = lib.mkDefault "mocha";
  catppuccin.enable = lib.mkDefault true;
  catppuccin.zsh-syntax-highlighting.enable = lib.mkDefault false;

  ghostty.enable = lib.mkDefault true;

  spotify-unfree.enable = lib.mkDefault true;

  yazi.enable = lib.mkDefault true;

  btop.enable = lib.mkDefault true;

  tmux.enable = lib.mkDefault true;

  zsh.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;

  programs.home-manager.enable = lib.mkDefault true;
}
