{self, ...}: {
  flake.nixosModules.git = {...}: {
    home-manager.sharedModules = with self.homeModules; [git];
  };

  flake.homeModules.git = {
    config,
    lib,
    ...
  }: let
    cfg = config.programs.git;
  in {
    config = lib.mkIf cfg.enable {
      programs.git = {
        lfs.enable = lib.mkDefault true;
        settings = {
          core.editor = lib.mkDefault "nvim";
          init.defaultBranch = lib.mkDefault "main";
          pull.rebase = lib.mkDefault true;
        };
      };

      home.shellAliases = {
        # Git Aliases
        gst = "git status";
        gd = "git diff";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gco = "git checkout";
      };
    };
  };
}
