{...}: {
  flake.nixosModules.piper = {pkgs, ...}: {
    services.ratbagd.enable = true;
    environment.systemPackages = with pkgs; [piper solaar];
  };
}
