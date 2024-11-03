{
  disko.devices.disk.main = {
    device = "/dev/sda";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          type = "EF00";
          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes = {
              "/" = {
                mountpoint = "/";
                mountOptions = [ "subvol=root" ];
              };
              "/persist" = {
                mountpoint = "/persist";
                mountOptions = [ "subvol=persist" ];
              };
              "/nix" = {
                mountpoint = "/nix";
                mountOptions = [ "subvol=nix" ];
              };
            };
          };
        };
      };
    };
  };
}
