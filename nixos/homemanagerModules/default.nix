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
    ./waybar
  ];

  programs.home-manager.enable = lib.mkDefault true;
}
