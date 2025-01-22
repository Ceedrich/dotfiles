{ ... } : {
  programs.git = {
    enable = true;
    userName = "Cedric Lehr";
    email = "info@ceedri.ch";
    extraConfig = {
      core.editor = "nvim";
      pull.rebase = false;
    };
  };
}
