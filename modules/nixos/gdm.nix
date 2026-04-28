{...}: {
  flake.nixosModules.gdm = {
    services.displayManager.gdm.enable = true;
    programs.dconf.profiles.gdm.databases = [
      {
        settings."org/gnome/login-screen" = {
          logo = "${../../assets/Ceedrich/Ceedrich.webp}";
        };
      }
    ];
  };
}
