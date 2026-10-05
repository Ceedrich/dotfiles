{self, ...}: {
  flake.nixosModules.host-ahsoka = {pkgs, ...}: {
    imports = with self.nixosModules; [
      ./_hardware-configuration.nix
      # ../jarjar/minecraft-servers
      system-graphical
      mangohud
      steam
      bluetooth
    ];

    home-manager.sharedModules = [
      {
        programs.mangohud.enable = true;
      }
    ];

    programs = {
      coolercontrol.enable = true;
      steam.enable = true;
    };
    environment.systemPackages = with pkgs; [
      lact
      clinfo
      # jetbrains.idea-oss
      jdk25
      prismlauncher

      aseprite
      handbrake
      ldtk
      tiled
    ];

    allowedUnfree = [
      "aseprite"
    ];

    hardware.graphics = {
      enable32Bit = true;
      enable = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };

    systemd.packages = with pkgs; [lact];
    systemd.services.lactd.wantedBy = ["multi-user.target"];

    system.stateVersion = "24.11";
  };
}
