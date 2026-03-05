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
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
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
        SearchEngines = {
          Remove = ["Google" "Bing" "Perplexity" "Wikipedia"];
          Default = "DuckDuckGo";
        };
      };
    };
    environment.etc."librewolf/librewolf/librewolf.overrides.cfg".text = ''
      pref("privacy.resistFingerprinting", false);
      pref("privacy.clearOnShutdown_v2.cookiesAndStorage", false);
    '';
    environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";
  }
