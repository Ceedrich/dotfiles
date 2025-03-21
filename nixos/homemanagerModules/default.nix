{ pkgs, lib, ... }: {
  imports = [
    ./hyprland
    ./git
    ./neovim
    ./shell
    ./ghostty
    ./brave
    ./spotify
    ./btop
    ./yazi
    ./tmux
    ./modrinth
    ./shortcuts
    ./minesweeper
    ./discord
  ];

  gtk = let key = "gtk-application-prefer-dark-theme"; in {
    enable = true;
    gtk3.extraConfig = {
      ${key} = 1;
    };
    gtk4.extraConfig = {
      ${key} = 1;
    };
    iconTheme = {
      name = "Parirus-Dark";
      package = pkgs.papirus-icon-theme;
      # name = "Qogir";
      # package = pkgs.qogir-icon-theme;
    };
  };
  catppuccin.gtk.enable = true;

  catppuccin.flavor = lib.mkDefault "mocha";
  catppuccin.enable = lib.mkDefault true;
  catppuccin.zsh-syntax-highlighting.enable = lib.mkDefault false;

  shortcuts.enable = lib.mkDefault true;

  ghostty.enable = lib.mkDefault true;

  # discord-unfree.enable = lib.mkDefault false;
  # spotify-unfree.enable = lib.mkDefault false;
  # modrinth-unfree.enable = lib.mkDefault false;

  yazi.enable = lib.mkDefault true;

  btop.enable = lib.mkDefault true;

  tmux.enable = lib.mkDefault true;

  brave.enable = lib.mkDefault true;

  neovim.enable = lib.mkDefault true;

  zsh.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;

  hyprland.enable = lib.mkDefault true;

  programs.home-manager.enable = lib.mkDefault true;
}
