{
  dbus,
  libfprint,
  fetchFromGitHub,
  writeText,
  innoextract,
  glib,
  gusb,
  json-glib,
  lib,
  libcap,
  libfprint-tod,
  libseccomp,
  libusb1,
  meson,
  ninja,
  openssl,
  pkg-config,
  stdenv,
  wget,
  fetchurl,
}: let
  installer = fetchurl {
    url = "https://download.lenovo.com/pccbbs/mobiles/r19fp02w.exe";
    hash = "sha256-CfBurJRksBhsGxyN7Xlppik3Lh14nPxsi9d3xydbaY8=";
  };

  patch =
    writeText "patch.diff"
    ''
      diff --git a/libfprint-tod/meson.build b/libfprint-tod/meson.build
      index 9e68c30..def4b97 100644
      --- a/libfprint-tod/meson.build
      +++ b/libfprint-tod/meson.build
      @@ -10,6 +10,7 @@ tudor_tod_src = [
       ]

       libfprint_tod_dep = dependency('libfprint-2-tod-1')
      +libfprint_dep = dependency('libfprint-2')
       udev_dep = dependency('udev')
       libusb_dep = dependency('libusb-1.0')
       gusb_dep = dependency('gusb')
      @@ -18,7 +19,7 @@ json_glib_dep = dependency('json-glib-1.0')
       tudor_tod = shared_module('tudor_tod',
           sources: tudor_tod_src,
           c_args: ['-D_GNU_SOURCE', '-Wno-missing-braces'],
      -    dependencies: [libfprint_tod_dep, libusb_dep, gusb_dep, json_glib_dep],
      +    dependencies: [libfprint_tod_dep, libfprint_dep, libusb_dep, gusb_dep, json_glib_dep],
           include_directories: [libtudor_inc, tudor_host_inc, tudor_host_launcher_inc],
           install: true,
           install_dir: libfprint_tod_dep.get_variable(pkgconfig: 'tod_driversdir')
      diff --git a/libtudor/download_driver.sh b/libtudor/download_driver.sh
      index 4450786..df0d186 100644
      --- a/libtudor/download_driver.sh
      +++ b/libtudor/download_driver.sh
      @@ -9,8 +9,7 @@ mkdir -p "$TMP_DIR"

       #Download the driver executable and check hash
       INSTALLER="$TMP_DIR/installer.exe"
      -wget https://download.lenovo.com/pccbbs/mobiles/r19fp02w.exe -O "$INSTALLER"
      -shasum "$INSTALLER" | cut -d" " -f1 | cmp - "$HASH_FILE"
      +cp ${installer} "$INSTALLER"

       #Extract the driver
       WINDRV="$TMP_DIR/windrv"
    '';
in
  stdenv.mkDerivation rec {
    pname = "synaTudor";
    version = "git";

    src = fetchFromGitHub {
      owner = "Popax21";
      repo = "synaTudor";
      rev = "master";
      sha256 = "sha256-/Uh9O2NahVcFg+lk5DkodECOTIyZZwcPs7OKOepagoQ=";
    };

    patches = [
      patch
    ];

    nativeBuildInputs = [
      innoextract
      meson
      ninja
      pkg-config
      wget
    ];

    buildInputs = [
      libfprint-tod
      libfprint
      glib
      json-glib
      libseccomp
      libcap
      dbus
      openssl
      libusb1
      gusb
    ];

    meta = with lib; {
      description = "Experimental Synaptics 06cb:00be driver";
      homepage = "https://github.com/Popax21/synaTudor";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  }
