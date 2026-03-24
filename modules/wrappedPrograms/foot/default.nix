{
  inputs,
  self,
  ...
}: {
  # adapted from https://github.com/Lassulus/wrappers/blob/0fe3161f35de2f7a4c894fdbaa1b681f5a62b617/modules/foot/module.nix
  flake.wrapperModules.foot = {
    lib,
    config,
    ...
  }: let
    iniFmt = config.pkgs.formats.iniWithGlobalSection {
      # from https://github.com/NixOS/nixpkgs/blob/89f10dc1a8b59ba63f150a08f8cf67b0f6a2583e/nixos/modules/programs/foot/default.nix#L11-L29
      listsAsDuplicateKeys = true;
      mkKeyValue = with lib.generators;
        mkKeyValueDefault {
          mkValueString = v:
            mkValueStringDefault {} (
              if v == true
              then "yes"
              else if v == false
              then "no"
              else if v == null
              then "none"
              else v
            );
        } "=";
    };
  in {
    options = {
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = '''';
      };
    };
    config = {
      "foot.ini".content =
        (builtins.readFile (iniFmt.generate "foot.ini" {
          globalSection = lib.filterAttrs (name: value: builtins.typeOf value != "set") config.settings;
          sections = lib.filterAttrs (name: value: builtins.typeOf value == "set") config.settings;
        }))
        + config.extraConfig;
      filesToExclude = [
        "share/applications/foot-server.desktop"
        "share/applications/footclient.desktop"
      ];
    };
  };

  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages.foot =
      (inputs.wrappers.wrapperModules.foot.apply {
        inherit pkgs;
        imports = [self.wrapperModules.foot];
        settings = {
          main = {
            font = "JetBrains Mono Nerd Font:size=14";
            title = "Terminal";
          };
          key-bindings = {
            scrollback-up-half-page = "Control+Shift+k";
            scrollback-down-half-page = "Control+Shift+j";
          };
        };
        extraConfig = builtins.readFile "${inputs'.catppuccin.packages.foot}/catppuccin-mocha.ini";
      }).wrapper;
  };
}
