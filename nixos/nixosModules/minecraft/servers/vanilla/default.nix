{ pkgs, ... }: {
  loader = "fabric";
  game_version = "1.21.4";
  mods = [
    "fabric-api"
    "cloth-config"
    "lithium"
    "tabtps"
    "simple-voice-chat"
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
    "beaconExtender"
  ];
  attrs = {
    whitelist = {
      # "Ceedrich" = "1764144b-fec5-4dbd-bd93-2b9e2530fa05";
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
    files = {
      "server-icon.png" = ./server-icon.png;
      "config/beaconExtender.json5" = {
        format = pkgs.formats.json {};
        value = {
          showBeaconLayers = true;
          maxLayers = 10;
          rangeFunctionType = "LINEAR";
          rangeFunctionParam1 = 10.0;
          rangeFunctionParam2 = 10.0;
          effectDurationFunctionType = "LINEAR";
          effectDurationFunctionParam1 = 10.0;
          effectDurationFunctionParam2 = 10.0;
        };
      };
    };
  };
}
