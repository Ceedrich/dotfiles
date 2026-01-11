{
  ceedrichPkgs,
  inputs,
  meta,
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
  ];
  environment.sessionVariables = {
    GTK_IM_MODULE = "gtk-im-context-simple";
    MANPAGER = "nvim +Man!";
  };
  environment.shellAliases = {
    dev = "nix develop --command zsh";
  };
  # Packages / Programs
  environment.systemPackages = with pkgs; [
    (pass.withExtensions (ext: with ext; [pass-otp pass-update pass-audit]))
    catppuccin-cursors.mochaMauve
    ceedrichPkgs.rebuild-system
    expect # TODO: move into module?
    fd
    file
    gnugrep
    gnupg
    gnutar
    jq
    just
    openconnect # TODO: move into module?
    pdfgrep
    ripgrep
    unzip
    vim
    wl-clipboard
    wlrctl
  ];

  programs = {
    btop.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;

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

  # GPG
  programs.gnupg.agent.enable = true;

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

  global-hm.config = {
    settings.theming.enable = true;
    programs = {
      neovim.enable = true;
      yazi.enable = true;
      tmux.enable = true;

      bash.enable = true;
      zsh = {
        enable = true;
        integrations.enable = true;
      };

      git = {
        enable = true;
        settings.user = {
          name = "Cedric Lehr";
          email = "info@ceedri.ch";
        };
      };
    };
  };

  services.tailscale = {
    enable = true;
    package = pkgs-unstable.tailscale;
  };
  programs.dconf.enable = true;

  # Nix settings
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
