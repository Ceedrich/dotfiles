{ pkgs, lib, config, ... }:

{
  options = {
    rofi.enable = lib.mkEnableOption "enable rofi";
  };
  config = lib.mkIf config.rofi.enable {
    programs.rofi = {
      enable = true;
      plugins = with pkgs; [ rofi-emoji-wayland ];
      extraConfig = {
        kb-row-down = "Control+j";
        kb-row-up = "Control+k";
        kb-remove-to-eol = "";
        kb-accept-entry = "Return";
      };
    };

    catppuccin.rofi.enable = true;
  };
}
