{lib, ...}: {
  imports = [
    ./btop
    ./git
    ./mangohud
    ./minesweeper # ERROR: Broken
    ./neovim
    ./rofi
    ./shell
    ./shortcuts
    ./theming
    ./tmux
    ./vpn
    ./yazi
  ];
  programs.rofi.enable = lib.mkDefault true;

  programs.home-manager.enable = lib.mkDefault true;
}
