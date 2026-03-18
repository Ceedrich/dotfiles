{lib, ...}: {
  imports = [
    ./git
    ./mangohud
    ./neovim
    ./rofi
    ./theming
    ./tmux
    ./vpn
    ./waybar
  ];
  programs.rofi.enable = lib.mkDefault true;

  programs.home-manager.enable = lib.mkDefault true;
}
