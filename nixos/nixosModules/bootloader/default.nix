{ lib, config, ... }:

{
  options = {
    bootloader.enable = lib.mkEnableOption "enable bootloader";
  };
  config = lib.mkIf config.bootloader.enable {

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

  };
}
