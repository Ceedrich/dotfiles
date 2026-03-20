{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nas.drives;
in {
  options.nas.drives = {
    system = lib.mkOption {
      type = lib.types.str;
      description = "Drive id as in `/dev/disk/by-id/`";
      example = "ata-STADFBBH1923DB";
    };
    hardDrives = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "hard drive names mapped to drive ids as in `/dev/disk/by-id/`";
      example = lib.literalExpression ''
        {
          hd1 = "ata-STADFBBH1923DB";
          hd2 = "ata-STADFBBH9823DB";
        }
      '';
    };
    solidStateDrives = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "ssd names mapped to drive ids as in `/dev/disk/by-id/`";
      example = lib.literalExpression ''
        {
          ssd1 = "ata-STADFBBH1923DB";
          ssd2 = "ata-STADFBBH9823DB";
        }
      '';
    };
  };

  config = let
    user = "ceedrich";
    hardDriveNames = lib.attrNames cfg.hardDrives;
  in {
    environment.systemPackages = with pkgs; [
      mergerfs
      mergerfs-tools
    ];

    fileSystems."/mnt/storage" = {
      device = lib.pipe hardDriveNames [
        (map (d: "/mnt/${d}"))
        (lib.concatStringsSep ":")
      ];
      fsType = "fuse.mergerfs";
      depends = map (d: "/mnt/${d}") hardDriveNames;
      options = [
        "defaults"
        "allow_other"
        "use_ino"
        "cache.files=auto-full"
        "dropcacheonclose=true"
        "category.create=epmfs"
        "category.search=ff"
        "func.getattr=newest"
        "minfreespace=10G"
        "fsname=mergerfs-storage"
      ];
    };

    systemd.tmpfiles.rules =
      map (drive: "d /mnt/${drive} 0755 ${user} ${user} -") hardDriveNames
      ++ [
        "d /mnt/storage 0775 servarr servarr -"
      ];

    disko.devices.disk = lib.mkMerge [
      (lib.mapAttrs (name: id: {
          type = "disk";
          device = "/dev/disk/by-id/${id}";
          content = {
            type = "gpt";
            partitions = {
              ${name} = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/mnt/${name}";
                  mountOptions = [
                    "defaults"
                    "noatime"
                    "nodiratime"
                    "user_xattr"
                  ];
                  extraArgs = ["-L" name];
                };
              };
            };
          };
        })
        cfg.hardDrives)
      {
        system = {
          type = "disk";
          device = "/dev/disk/by-id/${cfg.system}";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = ["umask=0077"];
                };
              };
              swap = {
                size = "4G";
                content = {
                  type = "swap";
                  randomEncryption = false;
                  resumeDevice = true;
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      }
    ];
  };
}
