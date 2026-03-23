{
  inputs,
  config,
  ...
}: let
  ceedrich = config.users.users.ceedrich;
in {
  imports = [inputs.sops-nix.nixosModules.sops];
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age = {
      sshKeyPaths = ["${ceedrich.home}/.ssh/id_ed25519"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };

  sops.secrets = {
    "vpn_epfl" = {
      owner = ceedrich.name;
    };
  };
}
