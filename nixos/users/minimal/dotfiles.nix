{...}: {
  settings.theming.enable = true;
  programs = {
    neovim.enable = true;
    btop.enable = true;
    yazi.enable = true;
    tmux.enable = true;

    zsh = {
      enable = true;
      integrations.enable = true;
    };

    git = {
      enable = true;
      userName = "Cedric Lehr";
      userEmail = "info@ceedri.ch";
    };
  };
}
