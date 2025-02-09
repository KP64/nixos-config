default_host := "rs"

# Builds an sd-Image for nixos on a raspberry 🥧
build host=default_host:
    nix shell nixpkgs#nix-output-monitor --command \
    nom build .#nixosConfigurations.{{ host }}.config.system.build.sdImage

# Show the 🥧 boot config
config host=default_host:
    nix build .#nixosConfigurations.{{ host }}.config.hardware.raspberry-pi.config-output
    @nix shell nixpkgs#bat --command bat result

[confirm("Are you sure you want to build and flash the img?")]
flash device host=default_host: (build host)
    for partition in $(lsblk -lno NAME | grep {{ device }}[0-9]); do \
      umount /dev/$partition || true; \
    done
    sudo wipefs -a /dev/{{ device }}
    sudo dd if=result/sd-image/kernel.img of=/dev/{{ device }} status=progress
