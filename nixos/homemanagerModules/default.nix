{ inputs, lib, ... }: {
  imports = [
    ./hyprland
    ./git
    ./neovim
    ./shell
    ./terminal
  ];

  catppuccin.flavor = lib.mkDefault "mocha";
  catppuccin.enable = lib.mkDefault true;
  catppuccin.zsh-syntax-highlighting.enable = lib.mkDefault false;

  ghostty.enable = lib.mkDefault true;

  zsh.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
}
