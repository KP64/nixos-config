{
  lib,
  config,
  inputs,
  username,
  ...
}:

{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.system.impermanence.enable = lib.mkEnableOption "Enable Impermanence";

  config = lib.mkIf config.system.impermanence.enable {

    programs.fuse.userAllowOther = true;
    fileSystems."/persist".neededForBoot = true;

    boot.initrd.postDeviceCommands =
      lib.mkAfter # bash
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

    environment.persistence."/persistent" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
        {
          directory = "/var/lib/colord";
          user = "colord";
          group = "colord";
          mode = "u=rwx,g=rx,o=";
        }
      ];
      files = [
        "/etc/machine-id"
        {
          file = "/var/keys/secret_file";
          parentDirectory = {
            mode = "u=rwx,g=,o=";
          };
        }
      ];
    };

    # TODO: Atomize Persistence to each Program
    home-manager.users.${username} = {
      imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

      home.persistence."/persist/home/${username}" = {
        allowOther = true;
        directories = [
          "Desktop"
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "Videos"
          "nixos-config"

          ".config"
          ".icons"
          ".local"
          ".mozilla"
          ".thunderbird"
          ".pki"
          ".gnupg"
          ".ssh"
          ".steam"
          ".vscode"
        ];
        files = [
          ".bash_history"
          ".screenrc"
        ];
      };
    };
  };
}
