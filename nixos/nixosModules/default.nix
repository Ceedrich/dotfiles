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

  bootloader.enable = lib.mkDefault true;
  networking.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [ wl-clipboard ];

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
