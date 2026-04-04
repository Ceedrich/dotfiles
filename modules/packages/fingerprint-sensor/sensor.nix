{...}: {
  perSystem = {pkgs, ...}: {
    packages.libfprint-2-tod1-synatudor = pkgs.callPackage ./_package.nix {};
  };

  flake.nixosModules.fingerprint-sensor = {selfpkgs, ...}: {
    environment.systemPackages = [selfpkgs.libfprint-2-tod1-synatudor];
    services.dbus.packages = [selfpkgs.libfprint-2-tod1-synatudor];
    systemd.packages = [selfpkgs.libfprint-2-tod1-synatudor];

    # By default fprintd is activated on the first use.
    # But libfprint-2-tod1-synatudor takes a long time to startup which causes big delays on first authentication attempt.
    # Startup fprintd on boot instead.
    systemd.units."fprintd.service".wantedBy = ["multi-user.target"];
    services.fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver = selfpkgs.libfprint-2-tod1-synatudor;
    };
  };
}
