{ pkgs, lib, config, ... }: {
  options = {
    spotify-unfree.enable = lib.mkEnableOption "enable spotify";
  };
  config = lib.mkIf config.spotify-unfree.enable
    /* lib.warn "Using unfree software spotify" */
    {
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "spotify"
      ];
      home.packages = with pkgs; [
        spotify
      ];

    };
}
