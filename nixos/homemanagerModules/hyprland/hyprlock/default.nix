{
  lib,
  config,
  ...
}: {
  options = {
    hyprlock.enable = lib.mkEnableOption "enable hyprlock";
  };
  config = lib.mkIf config.hyprlock.enable {
    programs.hyprlock = {
      enable = true;
      # extraConfig = lib.readFile ./hyprlock.conf;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
        };
        background = [
          {
            monitor = "";
            path = "${../hyprpaper/wallpaper.jpg}";
            blur_passes = 3;
            brightness = 0.5;
            color = "$base";
          }
        ];
        label = [
          # Time
          {
            monitor = "";
            text = ''cmd[update:30000] echo "$(date +"%R")"'';
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
            capslock_color = "$yellow";
            position = "0, -35";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
