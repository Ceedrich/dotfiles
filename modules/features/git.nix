{
  inputs,
  moduleWithSystem,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.git = inputs.wrappers.wrappers.git.wrap {
      inherit pkgs;
      settings = {
        core.editor = "nvim";
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
