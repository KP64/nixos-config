toplevel@{ inputs, ... }:
{
  flake.modules.nixos.hosts-morgiana = {
    imports = [
      inputs.disko.nixosModules.default
      toplevel.config.flake.diskoConfigurations.rpi-ext4
    ];
  };
}
