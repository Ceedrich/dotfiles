{...}: {
  flake.nixosModules.hyprlock = {
    lib,
    config,
    ...
  }: let
    cfg = config.programs.hyprlock;
  in {
    config.home-manager.sharedModules = lib.mkIf cfg.enable [
      {
        catppuccin.hyprlock.useDefaultConfig = false;
        programs.hyprlock = {
          enable = true;
          package = null;

          settings = {
            general = {
              ignore_empty_input = true;
              hide_cursor = true;
              fail_timeout = 800;
            };
            auth = {
              pam.enabled = true;
              fingerprint.enabled = true;
            };
            background = [
              {
                monitor = "";
                path = "${../../../assets/wallpaper.png}";
                blur_passes = 3;
                brightness = 0.5;
                color = "$base";
              }
            ];
            label = [
              # Time
              {
                monitor = "";
                text = "$TIME";
                color = "$text";
                font_size = 90;
                font_family = "$font";
                position = "-50, -20";
                halign = "right";
                valign = "top";
              }
              # Date
              {
                monitor = "";
                text = ''cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"'';
                color = "$text";
                font_size = 25;
                font_family = "$font";
                position = "-50, -170";
                halign = "right";
                valign = "top";
              }
              # Fingerprint Prompt
              {
                monitor = "";
                color = "$subtext0";
                font_family = "$font";
                font_size = 10;
                halign = "center";
                position = "0, -85";
                text = "$FPRINTPROMPT";
              }
            ];

            input-field = [
              {
                monitor = "";
                size = "300, 60";
                outline_thickness = 4;
                dots_size = 0.2;
                dots_spacing = 0.2;
                dots_center = true;
                outer_color = "$accent";
                inner_color = "$surface0";
                font_color = "$text";
                fade_on_empty = false;
                placeholder_text = ''<span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>'';
                hide_input = false;
                check_color = "$accent";
                fail_color = "$red";
                fail_text = ''<i>$FAIL <b>($ATTEMPTS)</b></i>'';
                fail_timeout = 800;
                capslock_color = "$yellow";
                position = "0, -35";
                halign = "center";
                valign = "center";
              }
            ];
          };
        };
      }
    ];
  };
}
