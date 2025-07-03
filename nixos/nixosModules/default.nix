{ pkgs, inputs, lib, ... }: {
  imports = [
    ./kanata
    ./hyprland
    ./fonts
    ./steam
    ./locales
    ./audio
    ./networking
    ./users
    ./bootloader
    inputs.catppuccin.nixosModules.catppuccin
  ];

  services.blueman.enable = true;

  bootloader.enable = lib.mkDefault true;
  networking.enable = lib.mkDefault true;

  hyprland.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
    unzip
    gnutar
    pdfgrep
    gnugrep
    jq
    (callPackage ../packages/rebuild_system.nix { })
  ];

  catppuccin.flavor = lib.mkDefault "mocha";
  catppuccin.enable = lib.mkDefault true;

  users = {
    enable = lib.mkDefault true;
    ceedrich = lib.mkDefault true;
  };
  locales.enable = lib.mkDefault true;
  audio.enable = lib.mkDefault true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
