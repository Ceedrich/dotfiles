{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.firefox;
in
  lib.mkIf cfg.enable {
    programs.firefox = {
      package = lib.mkDefault pkgs.librewolf;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        Preferences = {
          "browser.tabs.closeWindowWithLastTab" = false;
          "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
          "cookiebanners.service.mode" = 2; # Block cookie banners
          "privacy.donottrackheader.enabled" = true;
          "privacy.fingerprintingProtection" = false;
          "privacy.resistFingerprinting" = false;
          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = false;
          "privacy.trackingprotection.socialtracking.enabled" = true;
        };
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };
    environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";
  }
