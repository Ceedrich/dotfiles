{...}: {
  imports = [
    ./vanillaish
  ];
  allowedUnfree = ["minecraft-server"];
  services.minecraft-servers = {
    enable = true;
    eula = true;
  };
}
