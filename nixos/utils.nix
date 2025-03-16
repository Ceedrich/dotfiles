{}: {
  generateConfigs = func: names: builtins.listToAttrs (builtins.map
    (
      name: {
        inherit name;
        value = func name;
      }
    )
    names
  );
  warnIfUnfree = pkg:
    if (pkg.meta.licence.free or true == false) then
      builtins.warn
        "Warning: Using unfree package ${pkg.name}"
        pkg
    else pkg;
}
