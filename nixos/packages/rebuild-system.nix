{
  writeShellApplication,
  alejandra,
  gnugrep,
}: let
  rebuild-system = writeShellApplication {
    name = "rebuild-system";
    runtimeInputs = [
      gnugrep
      alejandra
    ];
    text = ''
      set -eo pipefail
      pushd ~/dotfiles/nixos/
      trap popd exit

      alejandra . &>/dev/null || true
      git diff -U0 .
      echo "Nixos Rebuilding..."
      sudo nixos-rebuild switch --flake . 2>&1 | tee nixos-switch.log >&2 || (
        echo "Build failed!" &&
        cat nixos-switch.log | grep --color -C 3 -E "error|warning" && false
      )
      gen=$(nixos-rebuild list-generations | awk '$8 == "True" {print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 }')
      git add .
      git commit -am "$(hostname): $gen"
      command -v notify-send>/dev/null || exit
      notify-send "NixOS rebuilt successfully!" --icon=nix-snowflake-white
    '';
  };
in
  rebuild-system
