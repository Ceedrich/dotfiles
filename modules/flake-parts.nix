{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      modules = inputs.nixpkgs.lib.mkOption {
        default = {};
      };
      wrapperModules = inputs.nixpkgs.lib.mkOption {
        default = {};
      };
      homemanagerModules = inputs.nixpkgs.lib.mkOption {
        default = {};
      };
    };
  };
}
