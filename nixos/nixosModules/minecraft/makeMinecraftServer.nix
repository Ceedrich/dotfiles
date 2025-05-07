{ game_version
, loader
, mods ? [ ]
, pkgs
}:

{
  enable = true;
  package =
    let
      version = builtins.replaceStrings [ "." ] [ "_" ] game_version;
    in
    pkgs."${loader}Servers"."${loader}-${version}";

  symlinks = {
    mods =
      pkgs.runCommandNoCC "mods.nix"
        {
          nativeBuildInputs = [
            (pkgs.callPackage ./modrinthPrefetch.nix { inherit loader game_version; })
          ];
        } "modrinth-prefetch ${builtins.toString mods} > $out";
  };
}
