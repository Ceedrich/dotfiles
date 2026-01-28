let
  mkMachine = hostname: args: args // {inherit hostname;};
in {
  rex = mkMachine "rex" {
    description = "Phone";
    tailscale = {
      ipv4 = "100.109.175.108";
      ipv6 = "fd7a:115c:a1e0::9401:af6c";
    };
    keys = {
      ssh = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCde6+GqW2Z4bDGNZw5Na2ywU8ESNfrIYtesNDczsXNOfg3qpeAi+HxOOOlWvnlLRC6PHUBk7rNrEednHgICA+LH2eBGbIZkBoLq1vZnvMI0N/Ou8zLtJ2yxbWIOpsTV8Qq575xGoWCxZGB+lx/Rzip8P2myS7KdiHb9o4I7gnRXIyd+pwbIB+NpR0zDpEJLuHYntEzXaperdsp6auttPCi18qPC2RYBZer0l1cHCBcmp5gURjF2eCfyOawMLPFXTA9RwYvl5LUDmaoIVBzgAqCZCTgMge4cXKML5AnBkU5YZhYAGq6gUPruqxgNiBHyE1jCVaC3IMSeNMjAOJHMY4t";
    };
  };

  cody = mkMachine "cody" {description = "Tablet";};

  ahsoka = mkMachine "ahsoka" {
    description = "PC";
    tailscale = {
      ipv4 = "100.108.51.52";
      ipv6 = "fd7a:115c:a1e0::9a01:3335";
    };
    keys = {
      ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL9QLT3DoOqnWd9g0GoV9Vgxc+RKgkLiri9eU2qgi8e5 ceedrich@gaming";
    };
  };

  satine = mkMachine "satine" {
    description = "Laptop";
    tailscale = {
      ipv4 = "100.127.118.118";
      ipv6 = "fd7a:115c:a1e0::c801:7688";
    };
    keys = {
      ssh = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZd2wl9brtYcLTQCTnV5HgBOZpT6ipwh5o46HBECSqYGphgsTWLk+l4LBn8Wgol+4FxtjVcxVGP0H74g1Yw6QxnLdUb3MNd3sAR0W0NDF0jbMsZuvTqmllqiuSoZO77TpcegN5+NVCgbzma0ITP6k+xlXPnw7jTxtOLFu01neZPPfOFmZMSJvKYrEozm89AoJWN48vO77OTfRnGpblp6yrYmlp/DQ+XOPXnNW6w0QqZVH71WH5d4UhftYbCJpbymgbTHjeamjb4Ohb7wBjVcxizQsse2oHwMvOxApdGAQJ06mQ7V6txUJVfeMhK4eq3D2rrSPllbn5vt9dHAZp2V6USRPlxQQDePx04MnURREpQGIXR0FAK2XUfg9uAnYxHj30rrd9HCUELqIkhhTJYMtwnordmeisHvHVZ+QvR6OXyaIC4E9gpcRFFPWM87OCHEmzuAnei1Okdk2V8d8F4pFsx2wSSyvZG22PfufZJ+Rffj+gzOb59yHR4m+F7Cbf7Xc= ceedrich@ceedrich-ubuntu";
    };
  };

  jabba = mkMachine "jabba" {
    description = "Cediflix Server";
    tailscale = {
      ipv4 = "100.113.168.35";
      ipv6 = "fd7a:115c:a1e0::5001:a826";
    };
    services = {
      sonarr.subdomains = ["sonarr"];
      radarr.subdomains = ["radarr"];
      prowlarr.subdomains = ["prowlarr"];
      deluge.subdomains = ["deluge"];
      homepage-dashboard.subdomains = ["home" "dashboard"];
      jellyfin.subdomains = ["jellyfin" "cediflix" "flix"];
    };
  };

  jarjar = mkMachine "jarjar" {
    description = "Minecraft Server";
    tailscale = {
      ipv4 = "100.94.165.18";
      ipv6 = "fd7a:115c:a1e0::1301:a524";
    };
    services = {
      pihole.subdomains = ["pihole"];
      uptime-kuma.subdomains = ["uptime-kuma" "uptime" "up"];
      minecraft.subdomains = ["minecraft" "mc"];
    };
  };
}
