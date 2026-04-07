{self, ...}: {
  flake.nixosModules.btop = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.programs.btop;
  in {
    options.programs.btop = {
      enable = lib.mkEnableOption "enable btop";
    };
    config = let
      package = pkgs.btop.override {rocmSupport = true;};
    in
      lib.mkIf cfg.enable {
        environment.systemPackages = [package];
        home-manager.sharedModules = with self.homemanagerModules; [btop];
      };
  };

  flake.homemanagerModules.btop = {
    programs.btop = {
      enable = true;
      package = null;
      settings.vim_keys = true;
    };
  };
}
