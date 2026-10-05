{...}: {
  flake.nixosModules.host-jarjar = {
    modulesPath,
    inputs,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      (modulesPath + "/profiles/qemu-guest.nix")
      inputs.disko.nixosModules.disko
      ./_disk-config.nix
      ./_minecraft-servers
      ./_hardware-configuration.nix
    ];

    system.stateVersion = "24.11";

    networking.firewall.allowedTCPPorts = [22];

    services.openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = false;
        AllowUsers = null;
      };
    };
  };
}
