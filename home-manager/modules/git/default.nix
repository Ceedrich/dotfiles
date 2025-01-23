{ ... } : {
  programs.git = {
    enable = true;
    userName = "Cedric Lehr";
    userEmail = "info@ceedri.ch";
    extraConfig = {
      core.editor = "nvim";
      pull.rebase = false;
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
}
