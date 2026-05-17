toplevel@{ den, ... }:
{
  den.aspects.aladdin = {
    includes = with den.aspects; [
      fs
      fs._.btrfs
    ];

    nixos.imports = [ toplevel.config.flake.diskoConfigurations.aladdin ];
  };
}
