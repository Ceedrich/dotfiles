{
  flake.nixosModules.nextcloud-client = {pkgs, ...}: let
    package = pkgs.nextcloud-client;
  in {
    environment.systemPackages = [package];
    systemd.packages = [package];
    systemd.user.services."com.nextcloud.desktopclient.nextcloud".enable = true;
  };
}
