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

        config = {
          systemd = {
            coredump.enable = false;
            network.enable = true;
          };

          fonts.fontconfig.enable = lib.mkDefault false;

          hardware.bluetooth.powerOnBoot = false;

          console.useXkbConfig = true;
          boot = {
            loader = {
              timeout = 0;
              systemd-boot.bootCounting.enable = true;
            };
            tmp.cleanOnBoot = true;
            binfmt.preferStaticEmulators = true;
            bootspec.enableValidation = true;
          };
          documentation.enable = false;
          environment = {
            defaultPackages = [ ];
            stub-ld.enable = false;
          };
          networking = {
            useDHCP = false;
            dhcpcd.enable = false;

            wireless = {
              fallbackToWPA2 = false;
              scanOnLowSignal = false;
            };

            firewall = {
              pingLimit = "10/second burst 20 packets";
              checkReversePath = "strict";
              filterForward = true;
              rejectPackets = true;
            };
            nftables = {
              enable = true;
              flattenRulesetFile = true;
              flushRuleset = true;
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
            virtualisation.flushL1DataCache = "always";
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
          services = {
            journald.settings.Journal.Storage = "volatile";
            userborn.enable = true;
          };
          users.mutableUsers = false;
        };
      };
    };
  };
}
