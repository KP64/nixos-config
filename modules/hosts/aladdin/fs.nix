toplevel@{ inputs, ... }:
{
  den.aspects.aladdin.nixos = {
    imports = [
      inputs.disko.nixosModules.default
      toplevel.config.flake.diskoConfigurations.aladdin
    ];

    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };
  };
}
