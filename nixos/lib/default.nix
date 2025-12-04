{callPackage}: let
in {
  makeModFetcher = args: callPackage ../packages/modrinth-prefetch.nix args;
}
