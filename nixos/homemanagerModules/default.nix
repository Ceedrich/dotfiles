{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./hyprland # TODO
    ./git
    ./neovim 
    ./shell # TODO
    ./ghostty
    ./theming # TODO
    ./spotify
    ./mangohud
    ./btop
    ./yazi
    ./tmux
    ./modrinth
    ./shortcuts
    ./minesweeper # ERROR: Broken
    ./discord
  ];

  options = {minimal = lib.mkEnableOption "minimal config";};

  config = let
    extra = x: lib.mkIf (! config.minimal) x;
  in {
    theming.enable = extra (lib.mkDefault true);

    zsh.enable = lib.mkDefault true;

    hyprland.enable = extra (lib.mkDefault true);

    programs.home-manager.enable = lib.mkDefault true;
  };
}
