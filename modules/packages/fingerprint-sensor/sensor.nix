{...}: {
  perSystem = {pkgs, ...}: {
    packages.libfprint-2-tod1-synatudor = pkgs.callPackage ./_package.nix {};
  };

  flake.overlays.fingerprint-sensor = final: prev: {
    libfprint-tod = prev.libfprint-tod.overrideAttrs (prevAttrs: rec {
      version = "1.94.6+tod1";
      src = final.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "3v1n0";
        repo = "libfprint";
        rev = "v${version}";
        hash = "sha256-Ce56BIkuo2MnDFncNwq022fbsfGtL5mitt+gAAPcO/Y=";
      };
      mesonFlags =
        prevAttrs.mesonFlags
        ++ [
          "-Dudev_rules_dir=${placeholder "out"}/lib/udev/rules.d"
        ];
      nativeBuildInputs = prevAttrs.nativeBuildInputs;
      postPatch = ''
        ${prevAttrs.postPatch}
        patchShebangs ./libfprint/tod/tests/*.sh
      '';
    });

    fprintd-tod = prev.fprintd-tod.overrideAttrs rec {
      version = "1.94.3";
      src = final.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "libfprint";
        repo = "fprintd";
        rev = "v${version}";
        hash = "sha256-shH+ctQAx4fpTMWTmo3wB45ZS38Jf8RknryPabfZ6QE=";
      };
      patches = null;
      postPatch = prev.fprintd.postPatch;
    };
  };
}
