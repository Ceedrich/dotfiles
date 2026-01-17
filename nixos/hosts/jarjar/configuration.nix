{
  modulesPath,
  inputs,
  meta,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ./minecraft-servers
    ./hardware-configuration.nix
  ];

  system.stateVersion = "24.11";

  networking.firewall.allowedTCPPorts = [22];

  homelab.reverseProxies.uptime-kuma.port = 4000;
  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT = "4000";
    };
  };

  services.pihole.enable = true;
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = null;
    };
  };
}
