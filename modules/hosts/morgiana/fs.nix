toplevel@{ den, ... }:
{
  den.aspects.morgiana = {
    includes = [ den.aspects.fs ];

    nixos.imports = [
      toplevel.config.flake.diskoConfigurations.rpi-ext4
    ];
  };
}
