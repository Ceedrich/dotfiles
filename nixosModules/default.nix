{...}: {
  imports = [
    # ./secrets
    ./backup.nix
    ./bluetooth.nix
    ./btop
    ./clipboard
    ./eza
    ./firefox
    ./fzf
    ./homelab
    ./logoutCommands.nix
    ./power-menu
    ./shortcuts
    ./starship
    ./tailscale
    ./user-mime.nix
    ./yazi
  ];
}
