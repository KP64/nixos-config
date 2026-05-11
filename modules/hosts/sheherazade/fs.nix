toplevel@{ inputs, ... }:
{
  den.aspects.sheherazade.nixos = {
    imports = [
      inputs.disko.nixosModules.default
      toplevel.config.flake.diskoConfigurations.rpi-ext4
    ];
  };
}
