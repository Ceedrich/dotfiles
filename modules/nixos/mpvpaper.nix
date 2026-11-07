{
  flake.nixosModules.mpvpaper = {
    lib,
    pkgs,
    ...
  }: {
    systemd.user.services.mpvpaper = {
      enable = true;
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${lib.getExe pkgs.mpvpaper} -so "no-audio loop" "*" ${../../assets/wallpaper.mp4}'';
        Restart = "on-failure";
      };
    };
  };
}
