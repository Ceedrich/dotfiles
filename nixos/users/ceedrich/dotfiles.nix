{pkgs, ...}: {
  imports = [
    ../minimal/dotfiles.nix
  ];

  home.packages = with pkgs; [
    signal-desktop
    vlc
    audacity
  ];
  # Custom HM modules
  # settings = {};
  # applications = {};

  vpn.epfl = true;
  programs = {
    brave.enable = true;
    mangohud.enable = true;
  };
}
