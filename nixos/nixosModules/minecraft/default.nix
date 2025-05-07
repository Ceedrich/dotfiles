{ pkgs, lib, config, ... }:

{
  options = {
    minecraft.enable = lib.mkEnableOption "enable minecraft";
  };
  config =
    lib.mkIf config.minecraft.enable {
      allowedUnfree = [ "minecraft-server" ];
      services.minecraft-servers = {
        enable = true;
        eula = true;

        servers =
          let
            makeServer = name:
              let
                server = import ./servers/${name} { inherit pkgs lib; };
                inherit (server) loader;
                version = lib.replaceStrings [ "." ] [ "_" ] server.game_version;
              in
              {
                enable = true;
                package = pkgs."${loader}Servers"."${loader}-${version}";
                symlinks = {
                  mods = pkgs.linkFarmFromDrvs "mods" (
                    builtins.attrValues (import ./servers/${name}/mods.nix { inherit (pkgs) fetchurl; })
                  );
                };
              } // (if server ? attrs then server.attrs else { });
          in
          builtins.listToAttrs (builtins.map
            (name: {
              inherit name;
              value = makeServer name;
            })
            (builtins.attrNames (builtins.readDir ./servers))
          );
      };
    };
}
