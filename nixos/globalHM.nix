{
  lib,
  config,
  ...
}: let
  cfg = config.global-hm;
in {
  options.global-hm = let
    inherit (lib) types;
  in {
    users = lib.mkOption {
      type = types.listOf types.str;
      default = [];
    };
    config = lib.mkOption {
      description = "Full home manager config applied to all (normal) users";
    };
  };
  config = {
    warnings = lib.mkIf (cfg.users == []) [
      "global-hm.users is empty, this is likely a mistake!"
    ];
    home-manager.users = lib.genAttrs cfg.users (user: cfg.config);
  };
}
