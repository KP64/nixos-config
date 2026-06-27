{
  den,
  lib,
  inputs,
  ...
}:
{
  # TODO: Make this a full form when https://github.com/denful/flake-file/issues/121 closes.
  # NOTE: Shallow Cloning because .git directory could leak.
  flake-file.inputs.nix-invisible = {
    url = "git+ssh://git@github.com/KP64/nix-invisible?shallow=1";
    inputs = {
      flake-parts.follows = "flake-parts";
      import-tree.follows = "import-tree";
      nixpkgs.follows = "nixpkgs";
    };
  };

  den = {
    schema.user = {
      includes = [ den.batteries.host-aspects ];
      classes = lib.mkDefault [ "homeManager" ];
    };

    default = {
      includes = with den.batteries; [
        inputs'
        self'
        define-user
        hostname
      ];

      homeManager.imports = [ inputs.nix-invisible.modules.homeManager.invisibility ];

      nixos = {
        imports = [ inputs.nix-invisible.modules.nixos.invisibility ];

        boot.tmp.cleanOnBoot = true;
        documentation.enable = false;
        environment.defaultPackages = [ ];
        networking.nftables = {
          enable = true;
          flattenRulesetFile = true;
        };
        security = {
          polkit.enable = true;
          sudo-rs = {
            enable = true;
            execWheelOnly = true;
          };
          lockKernelModules = true;
          protectKernelImage = true;
          forcePageTableIsolation = true;
        };
        services.userborn.enable = true;
        system.tools.nixos-generate-config.enable = false;
        users.mutableUsers = false;
      };
    };
  };
}
