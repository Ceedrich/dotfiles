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
  options.programs.hyprland.modules.overview = {
    enable = lib.mkEnableOption "Overview" // {default = true;};
  };

  config.home-manager.sharedModules = lib.mkIf cfg.enable [
    {
      wayland.windowManager.hyprland = {
        plugins = [inputs.hyprland-scroll-overview.packages.${pkgs.stdenv.hostPlatform.system}.default];

        extraConfig =
          # lua
          ''require("plugins.scrolloverview")'';
      };
    }
  ];
}
