{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  hl = config.programs.hyprland;
  cfg = hl.modules.hyprbars;
in {
  options.programs.hyprland.modules.hyprbars = {
    enable = lib.mkEnableOption "Hyprbars" // {default = true;};
  };

  config.home-manager.sharedModules = lib.mkIf cfg.enable [
    {
      wayland.windowManager.hyprland = {
        plugins = [inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars];

        extraConfig =
          # lua
          ''require("plugins.hyprbars")'';
      };
    }
  ];
}
