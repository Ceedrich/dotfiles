{...}: {
  imports = [
    # ./secrets
    ./backup.nix
    ./homelab
    ./logoutCommands.nix
    ./user-mime.nix
  ];
}
