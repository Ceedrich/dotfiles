{self, ...}: {
  flake.nixosModules.sesh = {pkgs, ...}: {
    environment.systemPackages = [pkgs.sesh];
    environment.shellAliases = {
      "s" = "sesh connect $(sesh list | fzf)";
    };

    home-manager.sharedModules = with self.homeModules; [sesh];
  };

  flake.homeModules.sesh = {
    programs.sesh = {
      enable = true;
      settings = {
        sort_order = ["config"];
        default_session = {
          preview_command = "eza --all --git --icons --color=always {}";
          startup_command = "tmux split-window -h; nvim";
        };
      };
    };
    programs.fzf.tmux.enableShellIntegration = true;
  };
}
