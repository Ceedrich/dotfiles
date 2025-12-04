{pkgs, ...}: {
  services.minecraft-servers.servers."vanillaish" = {
    enable = true;
    package = pkgs.fabricServers.fabric-1_21_4;

    whitelist = {
      "Ceedrich" = "1764144b-fec5-4dbd-bd93-2b9e2530fa05";
      "FaLehp" = "6d4d2d76-244e-4951-b485-91ce987590da";
    };
    operators = {
      "Ceedrich" = "1764144b-fec5-4dbd-bd93-2b9e2530fa05";
    };

    serverProperties = {
      difficulty = 3; # hard
      enforce-whitelist = true;
      white-list = true;
      motd = "§6§l--- Ceedrich's Minecraft Server ---";
    };
    symlinks = {
      "mods" = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues (
        import ./mods.nix {inherit (pkgs) fetchurl;}
      ));
    };
  };
}
