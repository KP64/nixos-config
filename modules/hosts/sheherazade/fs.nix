toplevel@{ den, ... }:
{
  den.aspects.sheherazade = {
    includes = [ den.aspects.fs ];

    nixos.imports = [ toplevel.config.flake.diskoConfigurations.rpi-ext4 ];
  };
}
