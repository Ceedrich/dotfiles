{lib, ...}: {
  imports = [
    ./hyprland # TODO
    ./git
    ./neovim
    ./shell
    ./ghostty
    ./theming # TODO
    ./spotify
    ./mangohud
    ./btop
    ./yazi
    ./tmux
    ./modrinth
    ./shortcuts
    ./minesweeper # ERROR: Broken
    ./discord
  ];

  theming.enable = lib.mkDefault true;

  hyprland.enable = lib.mkDefault false;

  programs.home-manager.enable = lib.mkDefault true;
}
