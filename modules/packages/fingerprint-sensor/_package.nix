# From https://gist.github.com/MrQubo/b27c4f52afd6d727d523aa95c0b71580
{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  openssl,
  libusb1,
  libcap,
  libseccomp,
  glib,
  dbus,
  libfprint-tod,
  gusb,
  innoextract,
  gccForLibs,
  withCli ? false, # cli is for debug usage only
}: let
  rev = "d8d9b6dbd8163efd207b706672b740c277f25fb7";

  installer = fetchurl {
    url = "https://download.lenovo.com/pccbbs/mobiles/r19fp02w.exe";
    hash = "sha256-CfBurJRksBhsGxyN7Xlppik3Lh14nPxsi9d3xydbaY8=";
  };
in
  stdenv.mkDerivation {
    name = "libfprint-2-tod1-synatudor";

    # TODO: PR some changes to upstream and use patches for the rest.
    src = fetchFromGitHub {
      inherit rev;
      owner = "MrQubo";
      repo = "synaTudor";
      hash = "sha256-RP1ObwvCHGBb2Bt/cbFeTZ8PM3Que2a5FJ59tSGmW+s=";
    };

    preConfigure =
      ''
        # INSTALL_DIR has a hardcoded reference to /sbin
        substituteInPlace meson.build \
          --replace-fail '/sbin' '${placeholder "out"}/bin'
        substituteInPlace libtudor/download_driver.sh \
          --replace-fail 'wget https://download.lenovo.com/pccbbs/mobiles/r19fp02w.exe -O "$INSTALLER"'$'\n' 'cp ${installer} "$INSTALLER"'$'\n'
        # We already checked the hash. No need to add perl as dependency.
        sed -i '/shasum "$INSTALLER"/d' libtudor/download_driver.sh
      ''
      + lib.optionalString (!withCli) ''
        rm -r cli/
        sed -i '/cli/d' meson.build
      '';

    doCheck = true;
    enableParallelBuilding = false; # TODO: Change to true.

    nativeBuildInputs = [
      pkg-config
      meson
      ninja
      innoextract
    ];
    buildInputs = [
      openssl
      libusb1
      libcap
      libseccomp
      glib
      dbus
      libfprint-tod
      gusb
      gccForLibs.libgcc
    ];

    dontUseCmakeConfigure = true;

    env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0 -I${libfprint-tod}/include/libfprint-2";

    installPhase =
      ''
        runHook preInstall
        install -D tudor-host-launcher/tudor_host_launcher                         -t $out/bin/tudor
        install -D tudor-host/tudor_host                                           -t $out/bin/tudor
        install -D libtudor/libtudor.so                                            -t $out/lib
        install -D libfprint-tod/libtudor_tod.so                                   -t $out/lib/libfprint-2/tod-1
        install -D tudor-host-launcher/tudor-host-launcher.service                 -t $out/lib/systemd/system
        install -D $src/libfprint-tod/60-tudor-libfprint-tod.rules                 -t $out/lib/udev/rules.d
        install -D tudor-host-launcher/net.reactivated.TudorHostLauncher.service   -t $out/share/dbus-1/system-services
        install -D $src/tudor-host-launcher/net.reactivated.TudorHostLauncher.conf -t $out/share/dbus-1/system.d
      ''
      + lib.optionalString withCli ''
        install -D cli/tudor_cli                                                   -t $out/bin
      ''
      + ''
        runHook postInstall
      '';

    passthru.driverPath = "/lib/libfprint-2/tod-1";

    meta =
      {
      }
      // lib.optionalAttrs withCli {mainProgram = "tudor_cli";};
  }
