{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.vpn;

  mkVpn = {
    name,
    server,
    username,
    passwordPath,
    otpPath ? passwordPath,
  }:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = with pkgs; [
        openconnect
        (pass.withExtensions (e: with e; [pass-otp]))
      ];
      text = ''
        sudo ${pkgs.expect}/bin/expect ${./vpn.exp} ${server} ${username} "$(pass show ${passwordPath} | head -n1)" "$(pass otp ${otpPath})"
      '';
    };
in {
  options.vpn = {
    epfl = lib.mkEnableOption "EPFL vpn";
  };
  config = {
    home.packages = lib.optional cfg.epfl (mkVpn {
      name = "epfl-vpn";
      server = "vpn.epfl.ch";
      username = "lehr";
      passwordPath = "studium/epfl";
    });
  };
}
