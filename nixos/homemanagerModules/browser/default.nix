{ lib, config, ... }:

{
  options = {
    brave.enable = lib.mkEnableOption "enable brave";
  };
  config = lib.mkIf config.brave.enable {
    programs.brave.enable = true;
  };
}
