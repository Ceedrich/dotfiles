{lib, ...}: {
  programs.ghostty.enable = lib.mkDefault true;
  programs.hyprland.enable = lib.mkDefault true;
  services.hypridle.enable = lib.mkDefault true;
}
