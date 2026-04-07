{...}: {
  flake.nixosModules.kanata = {
    services.kanata = {
      enable = true;
      keyboards.default = {
        config = builtins.readFile ./_kanata.kbd;
      };
    };
  };
}
