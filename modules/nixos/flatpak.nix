{...}: {
  flake.nixosModules.flatpak = {
    services.flatpak = {
      enable = true;
      update.auto.enable = true;
      packages = [
        "com.modrinth.ModrinthApp"
      ];
    };
    environment.profileRelativeEnvVars = {
      XDG_DATA_DIRS = ["/var/lib/flatpak/exports/share"];
    };
  };
}
