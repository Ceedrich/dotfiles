{writeShellScriptBin}: let
  rebuild_system = writeShellScriptBin "rebuild-system" ''
    set -e
    pushd ~/dotfiles/nixos/
    git diff -U0 .
    echo "Nixos Rebuilding..."
    sudo nixos-rebuild switch --flake . &>nixos-switch.log || (
      echo hello &&
      cat nixos-switch.log | grep --color -C 3 -E "error|warning" && false
    )
    gen=$(nixos-rebuild list-generations | grep current)
    git add .
    git commit -em "$(hostname): $gen"
    popd
  '';
in
  rebuild_system
