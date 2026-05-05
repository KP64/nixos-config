toplevel@{ inputs, ... }:
{
  flake.modules.nixos.hosts-sheherazade = {
    imports = [
      inputs.disko.nixosModules.default
      toplevel.config.flake.diskoConfigurations.rpi-ext4
    ];
  };
}
