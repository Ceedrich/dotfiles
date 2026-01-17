{lib, ...}: {
  imports = [
    ./git
    ./mangohud
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
