# Nixos-configuration

## Make secrets editing available for new host

Run the following command to convert your public ssh key into a public age key.

```sh
nix run nixpkgs#ssh-to-age -- -i ~/.ssh/id_ed25519.pub
```

Then, add the key to the [.sops.yaml](./.sops.yaml) file

The private sops key should automatically be generated, assuming you have your private ssh key in `$HOME/.ssh/id_ed25519`
