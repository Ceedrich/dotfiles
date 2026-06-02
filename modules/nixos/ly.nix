{...}: {
  flake.nixosModules.ly = {config, ...}: {
    services.displayManager.ly = {
      enable = true;
      settings = {
        allow_empty_password = false;
        asterisk = "#";
        box_title = "Ceedrich on ${config.networking.hostName}";
        clear_password = true;
        vi_default_mode = "insert";
        vi_mode = true;
      };
    };
  };
}
