{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.tmux;
in {
  config = lib.mkIf cfg.enable {
    programs.tmux = {
      clock24 = true;
      baseIndex = 1;
      prefix = "C-space";
      mouse = true;

      extraConfig = ''
        unbind r
        bind X { confirm-before -p "kill-session? (y/n)" kill-session }
      '';

      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        {
          plugin = catppuccin;
          extraConfig = ''
            set -g status-position top
            set -g @catppuccin_flavor "mocha"

            set -g @catppuccin_window_left_separator ""
            set -g @catppuccin_window_right_separator " "
            set -g @catppuccin_window_middle_separator " █"
            set -g @catppuccin_window_number_position "right"
            set -g @catppuccin_window_status_enable "yes"

            set -g @catppuccin_window_default_fill "number"
            set -g @catppuccin_window_default_text "#W"

            set -g @catppuccin_window_current_fill "number"
            set -g @catppuccin_window_current_text "#W"

            set -g @catppuccin_status_modules_right "directory session"
            set -g @catppuccin_status_left_separator  " "
            set -g @catppuccin_status_right_separator ""
            set -g @catppuccin_status_fill "icon"
            set -g @catppuccin_status_connect_separator "no"

            set -g @catppuccin_directory_text "#{pane_current_path}"
          '';
        }
      ];
    };
  };
}
