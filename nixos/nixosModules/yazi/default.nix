{
  config,
  lib,
  ...
}: let
  cfg = config.programs.yazi;
  catppuccin = config.catppuccin;
in {
  config = let
    bash-zsh-wrapper = ''
      function yy() {
      	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      	command yazi "$@" --cwd-file="$tmp"
      	IFS= read -r -d "" cwd < "$tmp"
      	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
      	rm -f -- "$tmp"
      }
    '';
  in
    lib.mkIf cfg.enable {
      programs.yazi = {
        # From <https://github.com/catppuccin/nix/blob/main/modules/home-manager/yazi.nix>
        settings.theme = lib.mkMerge [
          (lib.importTOML "${catppuccin.sources.yazi}/${catppuccin.flavor}/catppuccin-${catppuccin.flavor}-${catppuccin.accent}.toml")
          {
            mgr.syntect_theme = lib.mkForce "${catppuccin.sources.bat}/Catppuccin ${lib.toSentenceCase catppuccin.flavor}.tmTheme";
          }
        ];
      };

      programs.bash.interactiveShellInit = bash-zsh-wrapper;
      programs.zsh.interactiveShellInit = bash-zsh-wrapper;
    };
}
