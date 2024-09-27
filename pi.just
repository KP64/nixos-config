default_host := "rs"


# Builds an sd-Image for nixos on a raspberry 🥧
build host=default_host:
    nom build .#nixosConfigurations.{{ host }}.config.system.build.sdImage


# Show the 🥧 boot config
config host=default_host:
    nom build .#nixosConfigurations.{{ host }}.config.hardware.raspberry-pi.config-output
    bat result


[confirm("Are you sure you want to build and flash the img?")]
flash device: build
    sudo dd if=result/sd-image/kernel.img of=/dev/{{ device }} status=progress
