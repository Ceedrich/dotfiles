{lib, ...}: {
  imports = [
    ./git
    ./mangohud
    ./neovim
    ./nwg-drawer
    ./rofi
    ./shell
    ./theming
    ./tmux
    ./vpn
    ./waybar
    ./yazi
  ];
  programs.rofi.enable = lib.mkDefault true;

  programs.home-manager.enable = lib.mkDefault true;
}
