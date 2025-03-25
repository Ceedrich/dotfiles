{ pkgs, lib, config, ... }:

{
  options = {
    users = {
      enable = lib.mkEnableOption "users";
      ceedrich = lib.mkEnableOption "ceedrich";
    };
  };

  config =
    let
      inherit (lib) mkIf;
      cfg = config.users;
    in
    mkIf cfg.enable {

      users = {
        defaultUserShell = pkgs.zsh;
      };
      programs.zsh.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.ceedrich = mkIf cfg.ceedrich {
        isNormalUser = true;
        description = "Cedric";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = [ ];
      };

    };
}
