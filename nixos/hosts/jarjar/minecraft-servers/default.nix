{inputs, ...}: {
  imports = [
    ./vanillaish
    ./minecraft-backup.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];
  allowedUnfree = ["minecraft-server"];
  services.minecraft-servers = {
    backups.restic = {
      enable = true;
      password = "restic";
    };
    openFirewall = true;
    enable = true;
    eula = true;
  };
}
