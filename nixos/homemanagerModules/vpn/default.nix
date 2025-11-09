{
  lib,
  config,
  ...
}: let
  cfg = config.vpn;
in {
  options.vpn = {
    epfl = lib.mkEnableOption "enable ";
  };
  config = {
    home.shellAliases.epfl-vpn =
      lib.mkIf cfg.epfl
      # host username password otp
      ''sudo expect ${./vpn.exp} vpn.epfl.ch lehr "$(pass show studium/epfl | head -n1)" "$(pass otp studium/epfl)"'';
  };
}
