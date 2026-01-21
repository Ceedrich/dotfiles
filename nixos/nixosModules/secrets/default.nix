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
    "vpn_epfl/username" = {
      owner = ceedrich.name;
    };
    "vpn_epfl/password" = {
      owner = ceedrich.name;
    };
    "ahsoka/ssh/ceedrich/id_ed25519" = {
      owner = ceedrich.name;
      mode = "600";
      path = "${ceedrich.home}/.ssh/id_ed25519";
    };
  };
}
