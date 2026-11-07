{inputs', ...}: {
  plugins = [inputs'.hyprland-plugins.packages.hyprbars];
  extraConfig = ''require("plugins.hyprbars")'';
}
