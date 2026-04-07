{lib, ...}: {
  imports = [
    ./mangohud
    ./tmux
    ./vpn
    ./waybar
  ];
  programs.home-manager.enable = lib.mkDefault true;
}
