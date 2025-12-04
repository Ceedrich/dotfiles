{
  lib,
  pkgs,
  ceedrichLib,
  ...
}: let
  loader = "fabric";
  version = "1.21.5";
  mods = [
    "appleskin"
    "bannerretrieval"
    "beaconextender"
    "chunky"
    "cloth-config"
    "clumps"
    "coord-finder"
    "enhanced-groups"
    "fabric-api"
    "jade"
    "just-mob-heads"
    "just-player-heads"
    "leaves-be-gone"
    "lithium"
    "melius-commands"
    "passive-endermen"
    "rei"
    "rightclickharvest"
    "simple-voice-chat"
    "voice-chat-interaction"
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
    package = let
      escapeVersion = v: lib.replaceStrings ["."] ["_"] v;
    in
      pkgs."${loader}Servers"."${loader}-${escapeVersion version}";

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
      "server-icon.png" = ./server-icon.png;
    };
    files = {
      "config/melius-commands/commands/info.json".value = {
        "id" = "info";
        "executes" = [
          {
            "command" = "tellraw @s [\"\",{\"text\":\"Ceedrich's Minecraft Server\",\"bold\":true,\"underlined\":true,\"color\":\"dark_green\"},\"\\n\",\"\\n\",{\"text\":\"Seed: \",\"color\":\"green\"},{\"text\":\"6942694997652268\",\"underlined\":true,\"color\":\"green\",\"clickEvent\":{\"action\":\"copy_to_clipboard\",\"value\":\"6942694997652268\"},\"hoverEvent\":{\"action\":\"show_text\",\"contents\":[{\"text\":\"Click to copy to clipboard\",\"italic\":true}]}},\"\\n\",\"\\n\",{\"text\":\"Commands:\",\"bold\":true,\"color\":\"gold\"},\"\\n\",{\"text\":\"\/info\",\"color\":\"gray\",\"clickEvent\":{\"action\":\"suggest_command\",\"value\":\"\/info\"}},\" shows this information panel about the server\",\"\\n\",{\"text\":\"\/coords\",\"italic\":true,\"color\":\"gray\",\"clickEvent\":{\"action\":\"suggest_command\",\"value\":\"\/coords\"}},\" lets you see\/manage the coordinates of different locations on the server. If you built  a farm or found a nice biome, let the others know with the command \",{\"text\":\"\/coords setplace <name>\",\"underlined\":true,\"color\":\"dark_aqua\",\"clickEvent\":{\"action\":\"suggest_command\",\"value\":\"\/coords setplace \"},\"hoverEvent\":{\"action\":\"show_text\",\"contents\":[{\"text\":\"Share your coordinates\",\"italic\":true}]}},\"\\n\",{\"text\":\"\/autojoingroup\",\"italic\":true,\"color\":\"gray\",\"clickEvent\":{\"action\":\"suggest_command\",\"value\":\"\/autojoingroup\"}},\" lets you automatically join a voice chat group when you join the server. Use \",{\"text\":\"\/autojoingroup set <name>\",\"underlined\":true,\"color\":\"dark_aqua\",\"clickEvent\":{\"action\":\"suggest_command\",\"value\":\"\/autojoingroup set \"},\"hoverEvent\":{\"action\":\"show_text\",\"contents\":[{\"text\":\"Set an auto join group\",\"italic\":true}]}},\" to set such a auto join group or \",{\"text\":\"\/autojoingroup remove <name>\",\"underlined\":true,\"color\":\"dark_aqua\",\"clickEvent\":{\"action\":\"suggest_command\",\"value\":\"\/autojoingroup remove \"},\"hoverEvent\":{\"action\":\"show_text\",\"contents\":[{\"text\":\"Remove an auto join group\",\"italic\":true}]}},\" to remove such a auto join group.\",\"\\n\",{\"text\":\"\/ping\",\"italic\":true,\"color\":\"gray\",\"clickEvent\":{\"action\":\"suggest_command\",\"value\":\"\/ping\"}},\" lets you check your current ping\",\"\\n\",\"\\n\",{\"text\":\"Extra Features: \",\"bold\":true,\"color\":\"gold\"},\"\\n\",\"- Leaves decay faster\",\"\\n\",\"- Players and mobs have a chance to drop their head on death.\",\"\\n\",\"- Endermen don't pick up \/ place down blocks.\",\"\\n\",\"- You can craft small blocks by putting a block into a grindstone.\",\"\\n\",\"\\n\",{\"text\":\"List of Ideas: \",\"bold\":true,\"color\":\"gold\"},{\"text\":\"github.com\/Ceedrich\/MC-Ideas\",\"underlined\":true,\"color\":\"dark_aqua\",\"clickEvent\":{\"action\":\"open_url\",\"value\":\"https:\/\/github.com\/Ceedrich\/MC-Ideas\"},\"hoverEvent\":{\"action\":\"show_text\",\"contents\":[{\"text\":\"Open link\",\"italic\":true}]}}]";
            "op_level" = 0;
          }
        ];
      };
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
