toplevel@{ den, ... }:
{
  den.aspects.mahdi = {
    includes = with den.aspects; [
      fs
      fs._.btrfs
    ];

    nixos.imports = [ toplevel.config.flake.diskoConfigurations.mahdi ];
  };
}
