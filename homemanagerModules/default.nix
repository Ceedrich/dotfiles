{lib, ...}: {
  imports = [
    ./git
    ./mangohud
    ./rofi
    ./tmux
    ./vpn
    ./waybar
  ];
  programs.rofi.enable = lib.mkDefault true;

  programs.home-manager.enable = lib.mkDefault true;
}
