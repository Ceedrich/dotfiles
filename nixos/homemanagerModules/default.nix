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
    ./discord
    ./vpn
    ./waybar
  ];

  programs.home-manager.enable = lib.mkDefault true;
}
