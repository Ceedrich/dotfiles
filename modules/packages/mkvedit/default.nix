{...}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.mkvedit = pkgs.writeShellApplication {
      name = "mkvedit";
      bashOptions = [];
      text = builtins.readFile ./mkvedit;
      runtimeInputs = [pkgs.mkvtoolnix-cli self'.packages.subtitler];
    };
  };
}
