{
  flake.diskoConfigurations.zarqa = {
    services.btrfs.autoScrub = {
      enable = true;
      # By default scrubs all mountpoints.
      # We use subvolumes so no need to scrub all of them.
      # Top level is enough (it will scrub the others too).
      fileSystems = [ "/" ];
    };

    disko.devices.disk.main = {
      type = "disk";
      device = "/dev/mmcblk0";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            device = "/dev/disk/by-label/FIRMWARE";
            priority = 1;
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/firmware";
              mountOptions = [
                "umask=0077"
                "noatime"
                "noauto"
                "x-systemd.automount"
                "x-systemd.idle-timeout=1min"
              ];
            };
          };
          root = {
            priority = 2;
            size = "100%";
            device = "/dev/disk/by-label/NIXOS_SD";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "noatime" ];
            };
          };
        };
      };
    };
  };
}
