{
  inputs,
  self,
  ...
}: {
  flake.deploy = let
    mkDeployNode = hostname: {
      sshUser,
      user ? "root",
      interactiveSudo ? true,
    }: let
      host = self.nixosConfigurations.${hostname};
    in {
      inherit hostname;
      profiles.system = {
        inherit sshUser user interactiveSudo;
        path =
          inputs.deploy-rs.lib.${host.pkgs.stdenv.hostPlatform.system}.activate.nixos host;
      };
    };
  in {
    remoteBuild = true;
    nodes = {
      jabba = mkDeployNode "jabba" {sshUser = "ceedrich";};
      jarjar = mkDeployNode "jarjar" {sshUser = "ceedrich";};
    };
  };
  flake.checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
}
