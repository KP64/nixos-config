toplevel@{ den, inputs, ... }:
{
  # TODO: Namespaces
  den.default = {
    includes = with den.batteries; [
      inputs'
      self'
      define-user
      hostname
    ];

    schema = {
      host = {
        # TODO: Check if strict is for all
        strict = true;
        includes = [ den.batteries.host-aspects ];
      };
      user.includes = [ den.batteries.mutual-provider ];
    };

    homeManager.imports = [ inputs.nix-invisible.modules.homeManager.invisibility ];

    nixos = {
      imports =
        (with inputs; [
          nix-invisible.modules.nixos.invisibility
          nix-topology.nixosModules.default
          # TODO: Sops-Nix Secrets refactoring
          sops-nix.nixosModules.default
        ])
        ++ (with toplevel.config.flake.modules.nixos; [
          auto-timezone
          customLib
          home-manager
        ]);
      topology.self.services.openssh.hidden = false;

      boot = {
        tmp.cleanOnBoot = true;
        initrd.systemd.enable = true;
      };
      documentation = {
        enable = false;
        doc.enable = false;
        man.enable = false;
        info.enable = false;
        nixos.enable = false;
      };
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
      };
      services.userborn.enable = true;
      system.tools.nixos-generate-config.enable = false;
      users.mutableUsers = false;
    };
  };
}
