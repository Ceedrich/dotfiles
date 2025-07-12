{lib, ...}: {
  imports = [
    ./hyprland
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

  programs.home-manager.enable = lib.mkDefault true;
}
