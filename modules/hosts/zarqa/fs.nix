toplevel@{ den, ... }:
{
  den.aspects.zarqa = {
    includes = [ den.aspects.fs ];

    nixos.imports = [ toplevel.config.flake.diskoConfigurations.rpi-ext4 ];
  };
}
