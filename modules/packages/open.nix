{...}: {
  perSystem = {pkgs, ...}: {
    packages.open = pkgs.writeShellApplication {
      name = "open";
      text = ''
        xdg-open "$@" &>/dev/null & disown
      '';
    };
  };
}
