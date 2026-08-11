{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.subtitler = pkgs.rustPlatform.buildRustPackage rec {
      name = "subtitler";
      src = inputs.subtitler;
      nativeBuildInputs = [pkgs.pkg-config];
      cargoLock = {
        lockFile = "${src}/Cargo.lock";
      };
    };
  };
}
