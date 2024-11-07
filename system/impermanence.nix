{
  config,
  lib,
  inputs,
  username,
  ...
}:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.system.impermanence.enable = lib.mkEnableOption "Enable Impermanence.";

  config = lib.mkIf config.system.impermanence.enable {
    home-manager.users.${username} = {
      imports = [ inputs.impermanence.homeManagerModules.impermanence ];
      home.persistence."/persist".allowOther = true;
    };

    programs.fuse.userAllowOther = true;

    services.btrfs.autoScrub.enable = true;

    fileSystems."/persist".neededForBoot = true;

    # TODO: Group them mounts together
    # TODO: More granular persistence across the board
    # If it doesn't break without it, its not needed ;)
    environment.persistence."/persist" = {
      hideMounts = true;
      directories =
        [
          "/etc/NetworkManager/system-connections"
          "/var/log"
        ]
        ++ (map (x: "/var/lib/${x}") [
          "bluetooth"
          "nixos"
          "btrfs" # records fs scrubbing status: https://btrfs.readthedocs.io/en/latest/Scrub.html
          "systemd/coredump"
        ]);

      users.${username}.directories = [
        "nixos-config"
        ".local/share/gnupg"
        ".gnupg"
        ".ssh"
      ];

    };

    # TODO: Use writers instead of multiline string?
    boot.initrd.postDeviceCommands =
      lib.mkAfter # sh
        ''
          mkdir /btrfs_tmp
          mount /dev/root_vg/root /btrfs_tmp
          if [[ -e /btrfs_tmp/root ]]; then
              mkdir -p /btrfs_tmp/old_roots
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
              mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          delete_subvolume_recursively() {
              IFS=$'\n'
              for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "/btrfs_tmp/$i"
              done
              btrfs subvolume delete "$1"
          }

          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
              delete_subvolume_recursively "$i"
          done

          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
        '';
  };
}
