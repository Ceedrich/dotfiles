{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  services.xserver.desktopManager.gnome.enable = true; # TODO: remove gnome

  environment.systemPackages = with pkgs; [
    vim
    ghostty
    home-manager
    wget
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  system.stateVersion = "24.11";

}
