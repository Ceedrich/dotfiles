{ pkgs, lib, ... }: {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
  ];
  home.packages = with pkgs; [
    spotify
  ];
  home.username = "ceedrich";
  home.homeDirectory = "/home/ceedrich";

  catppuccin.zsh-syntax-highlighting.enable = false;

  home.stateVersion = "24.11";
}
