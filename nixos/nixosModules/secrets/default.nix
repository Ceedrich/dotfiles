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

  secrets = {
    "vpn_epfl/username" = {
      owner = ceedrich.name;
    };
    "vpn_epfl/password" = {
      owner = ceedrich.name;
    };
    "ahsoka/ssh/ceedrich/id_ed25519" = {
      # path = "${ceedrich.home}/.ssh/id_ed25519";
    };
  };
}
