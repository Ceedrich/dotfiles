{
  flake.nixosModules.nextcloud-client = {pkgs, ...}: {
    environment.systemPackages = [pkgs.nextcloud-client];
    systemd.user.services."com.nextcloud.desktopclient.nextcloud".enable = true;
  };
}
