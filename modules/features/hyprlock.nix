{
  inputs,
  moduleWithSystem,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages.hyprlock = inputs.wrappers.wrappers.hyprlock.wrap {
      inherit pkgs;
      constructFiles.generatedConfig.content = lib.mkBefore "source = ${inputs'.catppuccin.packages.hyprlock}/mocha.conf";
      settings = {
        general = {
          ignore_empty_input = true;
          hide_cursor = true;
          fail_timeout = 2000;
        };
        auth = {
          pam.enabled = true;
        };
        background = [
          {
            monitor = "";
            path = "${../../assets/wallpaper.png}";
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
            font_color = "$mauve";
            fade_on_empty = false;
            placeholder_text = ''󰌾 Logged in as <i>$USER</i>'';
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
  };
  flake.nixosModules.hyprlock = moduleWithSystem ({self', ...}: {
    environment.systemPackages = [self'.packages.hyprlock];
  });
}
