{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages.yazi = inputs.wrappers.wrappers.yazi.wrap {
      inherit pkgs;

      settings.theme = lib.mkMerge [
        (lib.importTOML "${inputs'.catppuccin.packages.yazi}/mocha/catppuccin-mocha-mauve.toml")
        {
          mgr.syntect_theme = lib.mkForce "${inputs'.catppuccin.packages.bat}/Catppuccin Mocha.tmTheme";
        }
      ];
    };
  };

  flake.nixosModules.yazi = {...}: let
    bash-zsh-wrapper = ''
      function yy() {
      	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      	command yazi "$@" --cwd-file="$tmp"
      	IFS= read -r -d "" cwd < "$tmp"
      	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
      	rm -f -- "$tmp"
      }
    '';
  in {
    xdg.mime.defaultApplications = {"inode/directory" = "yazi.desktop";};
    programs.bash.interactiveShellInit = bash-zsh-wrapper;
    programs.zsh.interactiveShellInit = bash-zsh-wrapper;
  };
}
