{
  lib,
  config,
  ...
}: let
  cfg = config.settings.kanata;
in {
  options.settings.kanata = {
    enable = lib.mkEnableOption "enable kanata";
    devices = lib.mkOption {
      default = [];
      type = lib.types.listOf lib.types.str;
      description = "The devices to apply the kanata config to. Applies to all if left empty";
      example = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"];
    };
  };
  config = lib.mkIf cfg.enable {
    services.kanata = {
      enable = true;
      keyboards.default = {
        config = builtins.readFile ./kanata.kbd;
        devices = cfg.devices;
      };
    };
  };
}
