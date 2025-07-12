{
  lib,
  config,
  ...
}: {
  options = {
    wofi.enable = lib.mkEnableOption "enable wofi";
  };
  config = lib.mkIf config.wofi.enable {
    programs.wofi = {
      enable = true;
      style = lib.readFile ./wofi.css;
    };
  };
}
