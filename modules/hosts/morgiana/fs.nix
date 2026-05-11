toplevel@{ inputs, ... }:
{
  den.aspects.morgiana.nixos = {
    imports = [
      inputs.disko.nixosModules.default
      toplevel.config.flake.diskoConfigurations.rpi-ext4
    ];
  };
}
