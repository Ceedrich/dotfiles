{ lib, config, ... }:

{
  options = {
    mangohud.enable = lib.mkEnableOption "enable mangohud";
  };
  config = lib.mkIf config.mangohud.enable {
    programs.mangohud = {
      enable = true;
      settings = {
        "fps_metric" = "avg,0.01";
        "font_scale" = 0.8;
        "gpu_stats" = true;
        "gpu_temp" = true;
        "gpu_fan" = true;
        "cpu_stats" = true;
        "cpu_temp" = true;
        "fps" = true;
        "frametime" = true;
        "throttling_status" = true;
        "text_outline" = true;
        "hud_compact" = true;
      };
    };
  };
}
