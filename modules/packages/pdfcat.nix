{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.pdfcat = pkgs.rustPlatform.buildRustPackage rec {
      name = "pdfcat";
      src = inputs.pdfcat;
      nativeBuildInputs = [pkgs.pkg-config];
      cargoLock = {
        lockFile = "${src}/Cargo.lock";
      };
    };
  };
}
