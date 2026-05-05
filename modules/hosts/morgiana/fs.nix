toplevel@{ inputs, ... }:
{
  flake.modules.nixos.hosts-aladdin = {
    imports = [
      inputs.disko.nixosModules.default
      toplevel.config.flake.diskoConfigurations.rpi-ext4
    ];
  };
}
