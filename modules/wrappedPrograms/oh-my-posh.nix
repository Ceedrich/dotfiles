{
  self,
  inputs,
  lib,
  config,
  ...
}: {
  flake.wrapperModules.oh-my-posh = inputs.wrappers.lib.wrapModule ({config, ...}: let
    jsonFmt = config.pkgs.formats.json {};
  in {
    options = {
      settings = lib.mkOption {
        type = jsonFmt.type;
        default = {};
      };
    };
    config = let
      settings = config.settings // {"$schema" = "${config.package.src}/themes/schema.json";};
    in {
      package = config.pkgs.oh-my-posh;
      flags = {
        "--config" = "${jsonFmt.generate "oh-my-posh.json" settings}";
      };
    };
  });

  flake.nixosModules.oh-my-posh = {
    config,
    lib,
    selfpkgs,
    ...
  }: let
    cfg = config.programs.oh-my-posh;
  in {
    options.programs.oh-my-posh = {
      enable = lib.mkEnableOption "oh-my-posh";
    };
    config = lib.mkIf cfg.enable {
      environment.systemPackages = [selfpkgs.oh-my-posh];
      programs.bash.shellInit = "eval $(oh-my-posh init bash)";
      programs.zsh.shellInit = "eval $(oh-my-posh init zsh)";
    };
  };

  perSystem = {pkgs, ...}: {
    packages.oh-my-posh = let
      removeNewlines = lib.replaceString "\n" "";
    in
      (self.wrapperModules.oh-my-posh.apply {
        pkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        settings = {
          palette = lib.pipe config.catppuccin.colors [
            (lib.filterAttrs (_: clr: clr?rgb))
            (lib.mapAttrs (_: clr: clr.hex))
          ];
          blocks = [
            {
              type = "prompt";
              alignment = "left";
              segments = [
                {
                  foreground = "p:blue";
                  properties = {
                    style = "full";
                    home_icon = "󰋜";
                  };
                  style = "plain";
                  template = removeNewlines ''
                    {{ if .Segments.Contains "Git" }}
                    <b><p:sapphire>../{{ .Segments.Git.RepoName }}</></b>
                    {{ if .Segments.Git.RelativeDir }}
                    /{{ .Segments.Git.RelativeDir }}
                    {{ end }}
                    {{ else }}
                    {{ .Path }}
                    {{ end }}
                  '';
                  type = "path";
                }
                {
                  type = "git";
                  foreground = "p:subtext0";
                  properties = {
                    branch_icon = "";
                    fetch_status = true;
                  };
                  style = "plain";
                  template = let
                    mkAdded = keys: "add " + lib.concatStringsSep " " keys;
                    mkAddedGit = keys:
                      lib.pipe keys [
                        (lib.map (key: ".Working.${key} .Staging.${key}"))
                        mkAdded
                      ];
                    mkGitLine = key: icon: ''
                      {{ if gt (${mkAddedGit [key]}) 0 }}
                      ${icon}{{ ${mkAddedGit [key]} }}
                      {{end}}
                    '';
                  in
                    removeNewlines ''
                       {{ .HEAD }}
                      <p:green>
                      {{ if gt (${mkAddedGit ["Added" "Modified"]}) 0}}
                       ${mkGitLine "Added" "+"}
                      ${mkGitLine "Modified" "~"}
                      {{end}}
                      </>
                      <p:red>
                      {{ if gt (${mkAddedGit ["Untracked" "Deleted"]}) 0 }}
                       ${mkGitLine "Untracked" "?"}
                      ${mkGitLine "Deleted" "-"}
                      {{end}}
                      </>
                      <p:green>
                      {{ if and (gt .Behind 0) (gt .Ahead 0 ) }}
                       ⇕
                      {{ else }}
                      {{ if gt .Behind 0 }}
                       ⇣{{ .Behind }}
                      {{ end }}
                      {{ if gt .Ahead 0 }} ⇡{{ .Ahead }}
                      {{ end }}
                      {{ end }}
                      </>
                    '';
                }
                {
                  type = "text";
                  template = " ❯";
                  foreground_templates = [
                    "{{if gt .Code 0}}p:red{{end}}"
                    "{{if eq .Code 0}}p:blue{{end}}"
                  ];
                  style = "plain";
                }
              ];
            }
            {
              type = "rprompt";
              overflow = "hidden";
              final_space = true;
              segments = [
                {
                  type = "status";
                  foreground = "p:red";
                  template = "<b>ERR{{ .Code }}</b> ";
                }
                {
                  type = "executiontime";
                  foreground = "p:yellow";
                  properties = {threshold = 5000;};
                  style = "plain";
                  template = "<b>󰔟{{ .FormattedMs }}</b> ";
                }
                {
                  type = "text";
                  template = "{{ if .Env.IN_NIX_SHELL }}(<b><p:blue> nix-shell</></b>) {{end}}";
                }
              ];
            }
          ];
          console_title_template = "{{ .Shell }} in {{ .Folder }}";
          final_space = true;
          secondary_prompt = {
            foreground = "p:blue";
            template = "❯❯ ";
          };
          transient_prompt = {
            background = "transparent";
            foreground_templates = [
              "{{if gt .Code 0}}p:red{{end}}"
              "{{if eq .Code 0}}p:blue{{end}}"
            ];
            template = "❯ ";
          };
          version = 2;
        };
      }).wrapper;
  };
}
