{
  lib,
  config,
  ...
}: let
  cfg = config.programs.mangohud;
in {
  config = lib.mkIf cfg.enable {
    programs.mangohud = {
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
