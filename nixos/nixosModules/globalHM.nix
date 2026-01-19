# TODO: look at `home-manager.sharedModules`, See also <https://home-manager.dev/manual/25.11/nixos-options.xhtml#nixos-opt-home-manager.sharedModules>
{
  pkgs,
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
    config =
      lib.mkOption {
        type = let
          jsonFormat = pkgs.formats.json {};
        in
          types.submodule {freeformType = jsonFormat.type;};
        description = "Full home manager config applied to all (normal) users";
      }
      // {
        merge = lib.types.merge;
      };
  };
  config = {
    warnings = lib.mkIf (cfg.users == []) [
      "global-hm.users is empty, this is likely a mistake!"
    ];
    home-manager.users = lib.genAttrs cfg.users (user: cfg.config);
  };
}
