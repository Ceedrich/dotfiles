{ config, pkgs, inputs, ... }:
let
  inherit (inputs.nix-minecraft.lib) collectFilesAt;
  modpack = pkgs.stdenvNoCC.mkDerivation {
    name = "ozone-skyblock-reborn";
    src = pkgs.fetchurl {
      url = "https://edge.forgecdn.net/files/6509/371/OSR%20Server%20-%201.17.3.zip";
      sha256 = "0xsmdb572pf7p4dnb39bz5wha31xbqpmxmlnwnwl22s9pdf2ww69";
    };
    nativeBuildInputs = [ pkgs.unzip ];
    unpackPhase = ''
      mkdir zipout
      unzip $src -d zipout
    '';
    installPhase = ''
      mkdir -p $out
      cp -r zipout/*/* $out
    '';
  };
in
{
  loader = "fabric";
  game_version = "1.21.4";
  attrs = {
    package = pkgs.writeShellApplication {
      runtimeInputs = with pkgs;[ openjdk21_headless ];
      name = "start-server";
      text =
        let
          dataDir = config.services.minecraft-servers.dataDir;
        in
        ''
          cd "${dataDir}/ozone-skyblock"
          sh ./start.sh
        '';
    };
    jvmOpts = "";
    operators = {
      "Ceedrich" = "1764144b-fec5-4dbd-bd93-2b9e2530fa05";
    };
    symlinks = collectFilesAt modpack "mods" // { };
    files = collectFilesAt modpack "config" // {
      "config/packmode-common.toml".value = {
        "Pack Mode" = "Expert";
        "Valid PackModes" = [ "Normal" "Expert" ];
      } //
      collectFilesAt modpack "defaultconfigs" //
      collectFilesAt modpack "kubejs" //
      collectFilesAt modpack "libraries" //
      collectFilesAt modpack "scripts" // {
        "default-server.properties" = "${modpack}/default-server.properties";
        "eula.txt" = "${modpack}/eula.txt";
        "user_jvm_args.txt".value = "-Xmx6G";
        "run.sh" = "${modpack}/run.sh";
      };
    };
  };
}
