{
  den,
  lib,
  inputs,
  ...
}:
{
  flake-file.inputs.nix-invisible = {
    # NOTE: Shallow Cloning because .git directory could leak.
    url = "git+ssh://git@github.com/KP64/nix-invisible?shallow=1";
    inputs = {
      flake-parts.follows = "flake-parts";
      import-tree.follows = "import-tree";
      nixpkgs.follows = "nixpkgs";
    };
  };

  den = {
    schema = {
      host = {
        strict = true;
        includes = [ den.batteries.host-aspects ];
      };
      user = {
        includes = [ den.batteries.mutual-provider ];
        classes = lib.mkDefault [ "homeManager" ];
      };
      home.includes = [ den.batteries.mutual-provider ];
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

        boot = {
          tmp.cleanOnBoot = true;
          initrd.systemd.enable = true;
        };
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
