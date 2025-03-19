# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  steam-unfree.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  networking.hostName = "gaming"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ceedrich = {
    isNormalUser = true;
    description = "Cedric";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  system.stateVersion = "24.11"; # Did you read the comment?

}
