{
  meta,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
  ];
  # Packages
  environment.systemPackages = with pkgs; [
    wl-clipboard
    unzip
    gnutar
    pdfgrep
    gnugrep
    gnupg
    jq
    openconnect # TODO: move into module?
    expect # TODO: move into module?
    (pass.withExtensions (ext: with ext; [pass-otp pass-update pass-audit]))
    (callPackage ../../packages/rebuild_system.nix {})
  ];

  # Theming
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = meta.hostname; # Define your hostname.
  networking.networkmanager.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Locale
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_CH.UTF-8";
    LC_IDENTIFICATION = "de_CH.UTF-8";
    LC_MEASUREMENT = "de_CH.UTF-8";
    LC_MONETARY = "de_CH.UTF-8";
    LC_NAME = "de_CH.UTF-8";
    LC_NUMERIC = "de_CH.UTF-8";
    LC_PAPER = "de_CH.UTF-8";
    LC_TELEPHONE = "de_CH.UTF-8";
    LC_TIME = "de_CH.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  console.keyMap = "sg";

  # Nix settings
  nix.settings.experimental-features = ["nix-command" "flakes"];
  programs.dconf.enable = true;
}
