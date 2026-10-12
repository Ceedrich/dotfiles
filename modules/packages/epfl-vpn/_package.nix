{
  openconnect,
  pass,
  writeShellApplication,
  expect,
}: let
  name = "epfl-vpn";
  server = "vpn.epfl.ch";
  username = "lehr";
  passwordPath = "studium/epfl";
  otpPath = passwordPath;
in
  writeShellApplication {
    inherit name;
    runtimeInputs = [
      openconnect
      (pass.withExtensions (e: with e; [pass-otp]))
      expect
    ];

    text = ''
      sudo expect ${./vpn.exp} "${server}" "${username}" "$(pass show ${passwordPath} | head -n1)" "$(pass otp ${otpPath})"
    '';
  }
