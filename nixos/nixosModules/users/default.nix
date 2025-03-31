{ pkgs, lib, config, ... }:

{
  options = {
    users = {
      enable = lib.mkEnableOption "users";
      ceedrich = lib.mkEnableOption "ceedrich";
    };
  };

  config =
    let
      inherit (lib) mkIf;
      cfg = config.users;
    in
    mkIf cfg.enable {

      users = {
        defaultUserShell = pkgs.zsh;
      };
      programs.zsh.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.ceedrich = mkIf cfg.ceedrich {
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZd2wl9brtYcLTQCTnV5HgBOZpT6ipwh5o46HBECSqYGphgsTWLk+l4LBn8Wgol+4FxtjVcxVGP0H74g1Yw6QxnLdUb3MNd3sAR0W0NDF0jbMsZuvTqmllqiuSoZO77TpcegN5+NVCgbzma0ITP6k+xlXPnw7jTxtOLFu01neZPPfOFmZMSJvKYrEozm89AoJWN48vO77OTfRnGpblp6yrYmlp/DQ+XOPXnNW6w0QqZVH71WH5d4UhftYbCJpbymgbTHjeamjb4Ohb7wBjVcxizQsse2oHwMvOxApdGAQJ06mQ7V6txUJVfeMhK4eq3D2rrSPllbn5vt9dHAZp2V6USRPlxQQDePx04MnURREpQGIXR0FAK2XUfg9uAnYxHj30rrd9HCUELqIkhhTJYMtwnordmeisHvHVZ+QvR6OXyaIC4E9gpcRFFPWM87OCHEmzuAnei1Okdk2V8d8F4pFsx2wSSyvZG22PfufZJ+Rffj+gzOb59yHR4m+F7Cbf7Xc= ceedrich@ceedrich-ubuntu"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCde6+GqW2Z4bDGNZw5Na2ywU8ESNfrIYtesNDczsXNOfg3qpeAi+HxOOOlWvnlLRC6PHUBk7rNrEednHgICA+LH2eBGbIZkBoLq1vZnvMI0N/Ou8zLtJ2yxbWIOpsTV8Qq575xGoWCxZGB+lx/Rzip8P2myS7KdiHb9o4I7gnRXIyd+pwbIB+NpR0zDpEJLuHYntEzXaperdsp6auttPCi18qPC2RYBZer0l1cHCBcmp5gURjF2eCfyOawMLPFXTA9RwYvl5LUDmaoIVBzgAqCZCTgMge4cXKML5AnBkU5YZhYAGq6gUPruqxgNiBHyE1jCVaC3IMSeNMjAOJHMY4t"
        ];
        isNormalUser = true;
        description = "Cedric";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = [ ];
      };

    };
}
