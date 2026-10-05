{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.host-satine = {pkgs, ...}: {
    imports = with self.nixosModules; [
      ./_hardware-configuration.nix
      inputs.musnix.nixosModules.musnix

      system-graphical
      kanata
      steam
      bluetooth
      mangowm
    ];
    boot.loader.grub.useOSProber = true; # Needed for grub to detect windows

    musnix.enable = true;

    programs = {
      steam.enable = true;
    };
    services.upower.enable = true;

    home-manager.sharedModules = [
      {
        wayland.windowManager.hyprland.extraConfig = ''hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })'';
      }
    ];

    environment.systemPackages = with pkgs; [
      snapshot
      # jetbrains.idea-oss
    ];

    hardware.graphics = {
      enable32Bit = true;
      enable = true;
    };

    networking.networkmanager.wifi.powersave = false;

    system.stateVersion = "24.11";
  };
}
