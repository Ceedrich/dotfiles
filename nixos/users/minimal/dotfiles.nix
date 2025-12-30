{pkgs, ...}: {
  settings.theming.enable = true;
  home.packages = with pkgs; [
    just
  ];
  home.shellAliases.dev = "nix develop --command zsh";
  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
  };
  programs = {
    neovim.enable = true;
    yazi.enable = true;
    tmux.enable = true;

    bash.enable = true;
    zsh = {
      enable = true;
      integrations.enable = true;
    };

    git = {
      enable = true;
      settings.user = {
        name = "Cedric Lehr";
        email = "info@ceedri.ch";
      };
    };
  };
}
