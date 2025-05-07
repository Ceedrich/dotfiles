{ pkgs, lib, config, ... }:

{
  options = {
    minecraft.enable = lib.mkEnableOption "enable minecraft";
  };
  config =
    let
      mkServer = import ./makeMinecraftServer.nix;
    in
    lib.mkIf config.minecraft.enable {
      allowedUnfree = [ "minecraft-server" ];
      services.minecraft-servers = {
        enable = true;
        eula = true;
        openFirewall = true;
        servers.vanillaIsh = mkServer {
          inherit pkgs;
          mods = [ "beaconExtender" "bannerRetrieval" ];
          game_version = "1.21.5";
          loader = "fabric";
        };
      };
    };
}
