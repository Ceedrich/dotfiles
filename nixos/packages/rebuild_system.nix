{writeShellScriptBin}: let
  rebuild_system = writeShellScriptBin "rebuild-system" ''
    set -eo pipefail
    pushd ~/dotfiles/nixos/
    git diff -U0 .
    echo "Nixos Rebuilding..."
    sudo nixos-rebuild switch --flake . 2>&1 | tee nixos-switch.log >&2 || (
      echo "Build failed!" &&
      cat nixos-switch.log | grep --color -C 3 -E "error|warning" && false
    )
    gen=$(nixos-rebuild list-generations | grep current)
    git add .
    git commit -em "$(hostname): $gen"
    popd
  '';
in
  rebuild_system
