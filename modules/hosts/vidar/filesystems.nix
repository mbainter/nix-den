{
  den.aspects.vidar.nixos = {
    boot = {
      # FIXME: migrate lanzaboote
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = 3;
      };
      initrd.systemd.enable = true;
    };

    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/disk/by-id/nvme-WD_BLACK_SN7100_1TB_250755802557";
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
                size = "48G";
                type = "8200";
                content = {
                  type = "luks";
                  name = "luks-swap";
                  initrdUnlock = true;
                  passwordFile = "/tmp/secret.key";
                  content = {
                    type = "swap";
                    randomEncryption = false;
                    resumeDevice = true;
                  };
                };
              };
              root = {
                size = "100%";
                type = "8300";
                content = {
                  type = "luks";
                  name = "luks-rpool";
                  initrdUnlock = true;
                  passwordFile = "/tmp/secret.key";
                  content = {
                    type = "zfs";
                    pool = "rpool";
                  };
                  settings = {
                    allowDiscards = true;
                    crypttabExtraOpts = ["tpm2-device=auto" "tpm2-measure-pcr=yes"];
                  };
                };
              };
            };
          };
        };
      };

      zpool = {
        rpool = {
          type = "zpool";
          options = {
            ashift = "12";
            autotrim = "on";
          };
          rootFsOptions = {
            acltype = "posixacl";
            canmount = "off";
            dnodesize = "auto";
            normalization = "formD";
            relatime = "on";
            xattr = "sa";
            mountpoint = "none";
          };
          postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^rpool/sys/root@blank$' || zfs snapshot rpool/sys/root@blank";

          datasets = {
            sys = {
              type = "zfs_fs";
              options.mountpoint = "none";
            };
            user = {
              type = "zfs_fs";
              options.mountpoint = "none";
              options."com.sun:auto-snapshot" = "true";
            };
            "sys/root" = {
              type = "zfs_fs";
              mountpoint = "/";
            };
            "sys/nix" = {
              type = "zfs_fs";
              mountpoint = "/nix";
            };
            "user/home" = {
              type = "zfs_fs";
              mountpoint = "/home";
            };
          };
        };
      };
    };

    fileSystems."/proc" = {
      device = "proc";
      fsType = "proc";
      options = ["defaults" "hidepid=2"];
      neededForBoot = true;
    };
  };
}
