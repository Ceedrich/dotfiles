{inputs, ...}: {
  imports = [
    ./vanillaish
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];
  allowedUnfree = ["minecraft-server"];
  services.minecraft-servers = {
    enable = true;
    eula = true;
  };
}
