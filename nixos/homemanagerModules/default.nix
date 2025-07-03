{ pkgs, lib, config, ... }: {
  imports = [
    ./hyprland
    ./git
    ./neovim
    ./shell
    ./ghostty
    ./brave
    ./theming
    ./spotify
    ./mangohud
    ./vlc
    ./signal
    ./btop
    ./yazi
    ./tmux
    ./modrinth
    ./shortcuts
    ./minesweeper
    ./discord
  ];

  options = { minimal = lib.mkEnableOption "minimal config"; };

  config =
    let
      extra = x: lib.mkIf (! config.minimal) x;
    in
    {
      home.packages = with pkgs; [ handbrake ];

      theming.enable = extra (lib.mkDefault true);

      signal.enable = extra (lib.mkDefault true);

      vlc.enable = extra (lib.mkDefault true);

      shortcuts.enable = extra (lib.mkDefault true);

      ghostty.enable = lib.mkDefault true;
      
      services.blueman-applet.enable = lib.mkDefault true;

      # discord-unfree.enable = lib.mkDefault false;
      # spotify-unfree.enable = lib.mkDefault false;
      # modrinth-unfree.enable = lib.mkDefault false;

      yazi.enable = extra (lib.mkDefault true);

      btop.enable = lib.mkDefault true;

      tmux.enable = lib.mkDefault true;

      brave.enable = lib.mkDefault true;

      neovim.enable = lib.mkDefault true;

      zsh.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;

      hyprland.enable = extra (lib.mkDefault true);

      programs.home-manager.enable = lib.mkDefault true;
    };
}
