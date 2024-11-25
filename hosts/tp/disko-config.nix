{
  disko.devices.disk.main = {
    device = "/dev/sda";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          type = "EF00";
          size = "512M";
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
          size = "100%";
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
                mountOptions = [ "noatime" ];
              };

              "/nix" = {
                mountpoint = "/nix";
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
    };
  };
}
