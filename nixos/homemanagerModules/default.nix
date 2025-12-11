{lib, ...}: {
  imports = [
    ./hyprland
    ./git
    ./neovim
    ./shell
    ./ghostty
    ./theming
    ./mangohud
    ./btop
    ./yazi
    ./tmux
    ./shortcuts
    ./minesweeper # ERROR: Broken
    ./vpn
  ];

  programs.home-manager.enable = lib.mkDefault true;
}
