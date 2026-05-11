toplevel@{ inputs, ... }:
{
  den.aspects.zarqa.nixos = {
    imports = [
      inputs.disko.nixosModules.default
      toplevel.config.flake.diskoConfigurations.rpi-ext4
    ];
  };
}
