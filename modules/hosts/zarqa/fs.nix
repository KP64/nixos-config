toplevel@{ inputs, ... }:
{
  flake.modules.nixos.hosts-zarqa = {
    imports = [
      inputs.disko.nixosModules.default
      toplevel.config.flake.diskoConfigurations.rpi-ext4
    ];
  };
}
