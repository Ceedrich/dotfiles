{ pkgs, ... }:
let 
  notify-send = "${pkgs.libnotify}/bin/notify-send";
in
{
  hardware.uinput.enable = true;
  services.kanata = {
    enable = true;

    package = pkgs.kanata-with-cmd;

    keyboards.default = {
      extraDefCfg = ''
        danger-enable-cmd yes 
        process-unmapped-keys yes
      '';
      config = ''
        (defsrc
          caps esc
          a s d f j k l ;
          lmet lalt lsft lctl rctl rsft ralt rmet
        )
        (defvar
          tap-time 200
          hold-time 150
        )

        (defalias
          a (tap-hold $tap-time $hold-time a lmet)
          s (tap-hold $tap-time $hold-time s lalt)
          d (tap-hold $tap-time $hold-time d lsft)
          f (tap-hold $tap-time $hold-time f lctl)
          j (tap-hold $tap-time $hold-time j rctl)
          k (tap-hold $tap-time $hold-time k rsft)
          l (tap-hold $tap-time $hold-time l ralt)
          ; (tap-hold $tap-time $hold-time ; rmet)
          switch-to-none (layer-switch none)
          switch-to-base (layer-switch base)
        )

        (deflayer base
          esc (multi @switch-to-none (cmd ${notify-send} "Keyboard" "Using default keybinds"))
          @a @s @d @f @j @k @l @;
          XX XX XX XX XX XX XX XX  
        )

        (deflayer none
          esc (multi @switch-to-base (cmd ${notify-send} "Keyboard" "Using home-row-mods"))
          a s d f j k l ;
          lmet lalt lsft lctl rctl rsft ralt rmet
        )
      '';
    };
  };
}
