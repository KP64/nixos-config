{
  disko.devices = {
    disk.main = {
      device = "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "umask=0077"
                "noatime"
              ];
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "root_vg";
            };
          };
        };
      };
    };
    lvm_vg.root_vg = {
      type = "lvm_vg";
      lvs.root = {
        size = "100%FREE";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes = {
            "/root" = {
              mountpoint = "/";
              mountOptions = [ "noatime" ];
            };

            "/persist" = {
              mountpoint = "/persist";
              mountOptions = [
                "subvol=persist"
                "noatime"
              ];
            };

            "/nix" = {
              mountpoint = "/nix";
              mountOptions = [
                "subvol=nix"
                "noatime"
              ];
            };
          };
        };
      };
    };
  };
}
