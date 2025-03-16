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
}
