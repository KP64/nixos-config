toplevel@{ inputs, ... }:
{
  flake.modules.nixos.hosts-aladdin = {
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
