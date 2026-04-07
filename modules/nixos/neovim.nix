{...}: {
  flake.nixosModules.neovim = {
    environment.sessionVariables = {
      MANPAGER = "nvim +Man!";
      EDITOR = "nvim";
    };
    environment.shellAliases = {
      v = "nvim";
      vimdiff = "nvim -d";
    };
  };
}
