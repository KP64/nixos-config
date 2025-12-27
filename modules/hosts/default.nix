{
  config,
  lib,
  inputs,
  self,
  ...
}:
let
  prefix = "hosts-";
in
{
  # TODO: Make Sops secrets reload necessary services
  flake.nixosConfigurations =
    config.flake.modules.nixos
    |> lib.filterAttrs (name: _: name |> lib.hasPrefix prefix)
    |> lib.mapAttrs' (
      name: module:
      let
        hostName = name |> lib.removePrefix prefix;

        # TODO: Remove this once https://github.com/nvmd/nixos-raspberrypi/issues/113 is closed
        inherit (inputs.nixpkgs) lib;
        baseLib = inputs.nixpkgs.lib;
        origMkRemovedOptionModule = baseLib.mkRemovedOptionModule;
        patchedLib = lib.extend (
          final: _: {
            mkRemovedOptionModule =
              optionName: replacementInstructions:
              let
                key = "removedOptionModule#" + final.concatStringsSep "_" optionName;
              in
              { options, ... }:
              (origMkRemovedOptionModule optionName replacementInstructions { inherit options; })
              // {
                inherit key;
              };
          }
        );
      in
      {
        name = hostName;
        value = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            lib = patchedLib;
          };
          modules = [
            # Modules that should be made available for everyone.
            config.flake.modules.nixos.nix-unfree
            inputs.nix-topology.nixosModules.default
          ]
          ++ [ module ] # The actual system config
          ++ [
            # Custom HM Defaults
            inputs.home-manager.nixosModules.default
            {
              # TODO: Refine the config to support useGlobalPkgs
              #       without it being a hassle
              home-manager = {
                useUserPackages = true;
                overwriteBackup = true;
                backupFileExtension = "hm-backup";
              };
              environment.pathsToLink = map (d: "/share/${d}") [
                "applications"
                "xdg-desktop-portal"
              ];
            }
          ]
          # Custom NixOS Defaults
          ++ [
            {
              users.mutableUsers = false;
              environment.defaultPackages = [ ];
              boot.tmp.cleanOnBoot = true;

              boot.initrd.systemd.enable = true;
              services.userborn.enable = true;
              system.tools.nixos-generate-config.enable = false;
              networking = {
                inherit hostName;
                # Let's help the adoption of nftables a bit ;)
                # NOTE: This might break some stuff like Docker & libvirtd
                nftables.enable = true;
              };
            }
          ]
          # Adds disko configuration if available
          ++ (lib.optionals (config.flake.diskoConfigurations |> lib.hasAttr hostName) [
            inputs.disko.nixosModules.default
            config.flake.diskoConfigurations.${hostName}
          ])
          # Adds facter configuration if available
          # TODO: Move to inhouse nixpkgs facter modules once facter is finally upstreamed
          ++ (
            let
              facterPath = self + /modules/hosts/${hostName}/facter.json;
            in
            lib.optionals (builtins.pathExists facterPath) [
              inputs.nixos-facter-modules.nixosModules.facter
              { facter.reportPath = facterPath; }
            ]
          );
        };
      }
    );

  flake.checks =
    config.flake.nixosConfigurations
    |> lib.mapAttrsToList (
      name: nixos: {
        ${nixos.config.nixpkgs.hostPlatform.system}."nixosConfigurations-${name}" =
          nixos.config.system.build.toplevel;
      }
    )
    |> lib.mkMerge;
}
