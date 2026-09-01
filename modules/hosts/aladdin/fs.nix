{ den, ... }: {
  den.aspects.aladdin = {
    includes = [ den.aspects.fs._.btrfs ];
    disko = {
      devices.disk.main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              priority = 2;
              size = "8G";
              content = {
                type = "swap";
                randomEncryption = true;
                priority = 100; # Always encrypt as long there is space for it
              };
            };
            luks = {
              priority = 3;
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes =
                    let
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    in
                    {
                      "@root" = {
                        mountpoint = "/";
                        inherit mountOptions;
                      };
                      "@home" = {
                        mountpoint = "/home";
                        inherit mountOptions;
                      };
                      "@nix" = {
                        mountpoint = "/nix";
                        inherit mountOptions;
                      };
                    };
                };
              };
            };
          };
        };
      };
    };
  };
}
