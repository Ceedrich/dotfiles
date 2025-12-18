{lib, ...}: {
  imports = [
    ./git
    ./mangohud
    ./minesweeper # ERROR: Broken
    ./neovim
    ./rofi
    ./shell
    ./theming
    ./tmux
    ./vpn
    ./yazi
  ];
  programs.rofi.enable = lib.mkDefault true;

  programs.home-manager.enable = lib.mkDefault true;
}
