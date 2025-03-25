{ lib, config, meta, ... }:

{
  options = {
    networking.enable = lib.mkEnableOption "enable networking";
  };
  config = lib.mkIf config.networking.enable {
    networking.hostName = meta.hostname; # Define your hostname.

    networking.networkmanager.enable = true;

  };
}
