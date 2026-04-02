{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.sesh;
in {
  options.programs.sesh = {
    enable = lib.mkEnableOption "Sesh";
    package = lib.mkPackageOption pkgs "sesh" {};
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    programs.zsh.interactiveShellInit =
      #sh
      ''
        function sesh-sessions() {
          {
            sesh connect $(sesh list | fzf)
          }
        }

        zle     -N             sesh-sessions
        bindkey -M emacs '^T' sesh-sessions
        bindkey -M vicmd '^T' sesh-sessions
        bindkey -M viins '^T' sesh-sessions
      '';
    programs.tmux.extraConfig =
      ''
        bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt
        set -g detach-on-destroy off  # don't exit from tmux when closing a session
      ''
      + ''
        bind-key "T" run-shell "sesh connect \"$(
          sesh list --icons | fzf --tmux -p 80%,70% \
            --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
            --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
            --bind 'tab:down,btab:up' \
            --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
            --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
            --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
            --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
            --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
            --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
            --preview-window 'right:55%' \
            --preview 'sesh preview {}'
        )\""
      '';
  };
}
