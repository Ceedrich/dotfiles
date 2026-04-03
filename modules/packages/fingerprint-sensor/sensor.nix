{...}: {
  perSystem = {pkgs, ...}: {
    packages.libfprint-2-tod1-synatudor = pkgs.callPackage ./_package.nix {};
  };

  flake.nixosModules.fingerprint-sensor = {selfpkgs, ...}: {
    services.fprintd.enable = true;
    services.dbus.packages = [selfpkgs.libfprint-2-tod1-synatudor];
    systemd.packages = [selfpkgs.libfprint-2-tod1-synatudor];
    systemd.units."fprintd.service".wantedBy = ["multi-user.target"];
    services.fprintd.tod = {
      enable = true;
      driver = selfpkgs.libfprint-2-tod1-synatudor;
    };
    environment.systemPackages = [selfpkgs.libfprint-2-tod1-synatudor];
  };
}
