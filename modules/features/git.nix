{
  inputs,
  moduleWithSystem,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.git = inputs.wrappers.wrappers.git.wrap {
      inherit pkgs;
      runtimePkgs = [self'.packages.delta];
      settings = {
        core = {
          editor = "nvim";
          pager = "delta";
        };

        interactive.diffFilter = "delta --color-only";

        delta.navigate = true;

        merge.conflictStyle = "zdiff3";

        init.defaultBranch = "main";

        pull.rebase = true;

        alias = {
          logg = "log --graph --abbrev-commit --decorate --oneline";
        };
      };
    };
  };

  flake.nixosModules.git = moduleWithSystem ({self', ...}: {pkgs, ...}: {
    programs.git = {
      enable = true;
      package = self'.packages.git;
    };
    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-all;
    };
  });
}
