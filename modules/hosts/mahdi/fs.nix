toplevel@{ inputs, ... }:
{
  flake.modules.nixos.hosts-mahdi = {
    imports = [
      inputs.disko.nixosModules.default
      toplevel.config.flake.diskoConfigurations.mahdi
    ];

    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };
  };
}
