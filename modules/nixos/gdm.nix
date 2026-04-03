{...}: {
  flake.nixosModules.gdm = {
    programs.dconf.profiles.gdm.databases = [
      {
        settings."org/gnome/login-screen" = {
          logo = "${../../assets/EPFL.png}";
        };
      }
    ];
  };
}
