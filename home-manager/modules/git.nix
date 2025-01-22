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
}
