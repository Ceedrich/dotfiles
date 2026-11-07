{inputs', ...}: {
  plugins = [inputs'.hyprland-scroll-overview.packages.default];
  extraConfig = ''require("plugins.scrolloverview")'';
}
