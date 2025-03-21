{ pkgs, inputs, lib, ... }: {
  imports = [
    ./kanata
    ./hyprland
    ./fonts
    ./steam
    ./locales
    inputs.catppuccin.nixosModules.catppuccin
  ];

  environment.systemPackages = with pkgs; [ wl-clipboard ];

  catppuccin.flavor = lib.mkDefault "mocha";
  catppuccin.enable = lib.mkDefault true;

  locales.enable = lib.mkDefault true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
