{...}: {
  imports = [
    # ./secrets
    ./backup.nix
    ./homelab
    ./logoutCommands.nix
    ./shortcuts
    ./user-mime.nix
  ];
}
