{
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

  config = lib.mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        wayland.windowManager.hyprland = {
          plugins = with pkgs; [hyprlandPlugins.hyprbars];

          settings.plugin.hyprbars = {
            bar_height = 28;
            bar_button_padding = 8;
            bar_blur = false;
            bar_color = "$crust";
            col.text = "$overlay0";
            bar_text_size = 12;
            bar_text_font = "JetBrains Mono Nerdfont";
            bar_part_of_window = true;
            bar_precedence_over_border = true;
            bar_buttons_alignment = "left";
            hyprbars-button = let
              size = toString 14;
            in [
              "$red, ${size},, hyprctl dispatch killactive"
              "$yellow, ${size},, hyprctl dispatch togglefloating"
              "$green, ${size},, hyprctl dispatch fullscreen toggle"
            ];
          };
        };
      }
    ];
  };
}
