{...}: {
  flake.nixosModules.fcitx5 = {...}: {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
    };
  };
}
