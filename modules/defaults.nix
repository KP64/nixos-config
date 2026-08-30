{
  den,
  lib,
  inputs,
  ...
}:
{
  # NOTE: Shallow Cloning because .git directory could leak.
  flake-file.inputs.nix-invisible = {
    type = "git";
    url = "ssh://git@github.com/KP64/nix-invisible";
    shallow = true;
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
        imports = with inputs.nix-invisible.modules.nixos; [
          invisibility
          homelab
        ];

        boot.tmp.cleanOnBoot = true;
        documentation.enable = false;
        environment.defaultPackages = [ ];
        networking = {
          firewall.pingLimit = "10/second burst 20 packets";
          nftables = {
            enable = true;
            flattenRulesetFile = true;
          };
        };
        security = {
          sudo-rs = {
            enable = true;
            execWheelOnly = true;
          };
          lockKernelModules = true;
          protectKernelImage = true;
          forcePageTableIsolation = true;
        };
        system = {
          # TODO: Enable when Sops-Nix works with that.
          # etc.overlay = {
          #   enable = true;
          #   mutable = false;
          # };
          # nixos-init.enable = true;
          tools.nixos-generate-config.enable = false;
        };
        services.userborn.enable = true;
        users.mutableUsers = false;
      };
    };
  };
}
