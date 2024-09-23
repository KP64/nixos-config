# Builds an sd-Image for nixos on a raspberry 🥧
pi:
    nix build .{{ "#" }}nixosConfigurations.rs.config.system.build.sdImage

# Show the 🥧 boot config
config:
    nix build .{{ "#" }}nixosConfigurations.rs.config.hardware.raspberry-pi.config-output
