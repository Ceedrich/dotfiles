{
  pkgs,
  ceedrichLib,
  ...
}: let
  loader = "fabric";
  version = "1.21.4";
  mods = [
    "rei"
    "appleskin"
    "fabric-api"
    "cloth-config"
    "lithium"
    "simple-voice-chat"
    "beaconextender"
    "voice-chat-interaction"
    "enhanced-groups"
    "jade"
    "accelerated-decay"
    "rightclickharvest"
    "just-player-heads"
    "just-mob-heads"
    "passive-endermen"
    "chunky"
    "coord-finder"
    "melius-commands"
    "clumps"
    "bannerretrieval"
  ];
in {
  environment.systemPackages = [
    (ceedrichLib.makeModFetcher {
      name = "vanillaish";
      inherit loader version mods;
    })
  ];
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
