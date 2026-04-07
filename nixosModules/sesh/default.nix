{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.sesh;
in {
  options.programs.sesh = {
    enable = lib.mkEnableOption "Sesh";
    package = lib.mkPackageOption pkgs "sesh" {};
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    environment.shellAliases = {
      "s" = "sesh connect $(sesh list | fzf)";
    };

    home-manager.sharedModules = [
      ({...}: {
        programs.sesh = {
          enable = true;
          settings = {
            sort_order = ["config"];
            default_session = {
              preview_command = "eza --all --git --icons --color=always {}";
              windows = ["nvim"];
            };
            window = [
              {
                name = "nvim";
                startup_script = "nvim";
              }
            ];
          };
        };
        programs.fzf.tmux.enableShellIntegration = true;
      })
    ];
  };
}
