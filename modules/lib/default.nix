toplevel@{ inputs, ... }:
{
  imports = [ inputs.nix-lib.flakeModules.default ];

  nix-lib.enable = true;

  flake.aspects.customLib = {
    nixos = {
      imports = [ inputs.nix-lib.nixosModules.default ];

      home-manager.sharedModules = [ toplevel.config.flake.modules.homeManager.customLib ];

      nix-lib.enable = true;
    };

    homeManager = {
      imports = [ inputs.nix-lib.homeModules.default ];

      nix-lib.enable = true;
    };
  };
}
