{
  lib,
  config,
  ...
}: let
  cfg = config.programs.git;
in {
  config = lib.mkIf cfg.enable {
    programs.git = lib.mkDefault {
      lfs.enable = true;
      settings = {
        core.editor = "nvim";
        init.defaultBranch = "main";
        pull.rebase = true;
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
}
