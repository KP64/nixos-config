toplevel@{ lib, inputs, ... }:
let
  prefix = "hosts-";
in
{
  # TODO: Use custom option for configs (nixos + hm) instead of flake module with prefix
  #       Could be that aspects will be the solution here
  flake = {
    nixosConfigurations =
      toplevel.config.flake.modules.nixos
      |> lib.filterAttrs (name: _: lib.hasPrefix prefix name)
      |> lib.mapAttrs' (
        name: module:
        let
          hostName = lib.removePrefix prefix name;
        in
        {
          name = hostName;
          value = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit (inputs) nixos-raspberrypi; };
            modules =
              # Modules that should be made available for everyone.
              (with toplevel.config.flake.modules.nixos; [
                auto-timezone
                customLib
                home-manager
                nix-unfree
              ])
              ++ [
                inputs.nix-topology.nixosModules.default
                { topology.self.services.openssh.hidden = false; }

                inputs.nix-invisible.modules.nixos.invisibility
                { home-manager.sharedModules = [ inputs.nix-invisible.modules.homeManager.invisibility ]; }

                module # The actual system config

                # Custom NixOS Defaults
                {
                  users.mutableUsers = false;
                  environment.defaultPackages = [ ];
                  boot.tmp.cleanOnBoot = true;

                  security.polkit.enable = true;

                  # From perlless profile
                  boot.initrd.systemd.enable = true;
                  services.userborn.enable = true;
                  system.tools.nixos-generate-config.enable = false;

                  networking = {
                    inherit hostName;
                    nftables.enable = true;
                  };
                }
              ]
              # Adds disko configuration if available
              ++ (lib.optionals (lib.hasAttr hostName toplevel.config.flake.diskoConfigurations) [
                inputs.disko.nixosModules.default
                toplevel.config.flake.diskoConfigurations.${hostName}
              ]);
          };
        }
      );

    checks =
      toplevel.config.flake.nixosConfigurations
      |> lib.mapAttrsToList (
        name: nixos: {
          ${nixos.config.nixpkgs.hostPlatform.system}."nixosConfigurations-${name}" =
            nixos.config.system.build.toplevel;
        }
      )
      |> lib.mkMerge;
  };
}
