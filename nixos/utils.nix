{}: {
  generateConfigs = mkConfig: set: builtins.mapAttrs (name: value: (mkConfig name value)) set;
  warnIfUnfree = pkg:
    if (pkg.meta.licence.free or true == false)
    then
      builtins.warn
      "Warning: Using unfree package ${pkg.name}"
      pkg
    else pkg;
}
