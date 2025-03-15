{ ... }: {
  imports = [
    ./kanata
    ./window-manager
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
