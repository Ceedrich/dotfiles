{ config, pkgs, inputs, ... }:
let
  port = 25566;
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
    postInstall = ''
      sed -i 's/^server-port=.*/server-port=${toString port}/' $out/default-server.properties
      sed -i 's/^query\.port=.*/query.port=${toString port}/' $out/default-server.properties
    '';
  };
in
{
  loader = "fabric";
  game_version = "1.21.4";
  attrs = {
    extraStartPre = ''
      echo "started at $(date)" >> minecraft-server.log
    '';
    package =
      pkgs.writeShellApplication {
        name = "start-server";
        runtimeInputs = with pkgs; [ jdk21 bash ];
        text = ''
          set -euo pipefail
          echo "start-server at $(date)"; ls -lah libraries/net/minecraftforge/forge/1.20.1-47.4.0/ >> minecraft-server.log
          exec >> minecraft-server.log 2>&1
          sh run.sh
        '';
      };

    serverProperties = {
      server-port = 25566;
      difficulty = 3;
    };
    symlinks = collectFilesAt modpack "mods" // { };
    files = (collectFilesAt modpack "config") // {
      "config/packmode-common.toml".value = {
        "Pack Mode" = "Normal";
        "Valid PackModes" = [ "Normal" "Expert" ];
      };
    } //
      (collectFilesAt modpack "defaultconfigs") //
      (collectFilesAt modpack "kubejs") //
      (collectFilesAt modpack "libraries") //
      (collectFilesAt modpack "scripts") // {
      "default-server.properties" = "${modpack}/default-server.properties";
      "eula.txt" = "${modpack}/eula.txt";
      "user_jvm_args.txt" = "${modpack}/user_jvm_args.txt";
      "run.sh" = "${modpack}/run.sh";
    };
  };
}
