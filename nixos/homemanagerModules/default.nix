{lib, ...}: {
  imports = [
    ./git
    ./mangohud
    ./neovim
    ./nwg-drawer
    ./rofi
    ./theming
    ./tmux
    ./vpn
    ./waybar
  ];
  programs.rofi.enable = lib.mkDefault true;

  programs.home-manager.enable = lib.mkDefault true;
}
