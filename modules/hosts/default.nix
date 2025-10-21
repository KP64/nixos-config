{
  config,
  lib,
  inputs,
  ...
}:
let
  prefix = "hosts-";
in
{
  flake.nixosConfigurations =
    config.flake.modules.nixos
    |> lib.filterAttrs (name: _: name |> lib.hasPrefix prefix)
    |> lib.mapAttrs' (
      name: module:
      let
        hostName = name |> lib.removePrefix prefix;
      in
      {
        name = hostName;
        value = inputs.nixpkgs.lib.nixosSystem {
          modules = [
            module # The actual system config
          ]
          ++ (with inputs; [
            nur.modules.nixos.default
            home-manager.nixosModules.default
          ])
          ++ [
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                overwriteBackup = true;
                backupFileExtension = "hm-backup";
              };
            }
            {
              users.mutableUsers = false;
              # Do not install rsync, perl & strace by default
              environment.defaultPackages = [ ];
              boot.tmp.cleanOnBoot = true;
              networking = {
                inherit hostName;
                # Let's help the adoption of nftables a bit ;)
                # NOTE: This might break some stuff like Docker & libvirtd
                nftables.enable = true;
              };

              # TODO: Enable once https://github.com/NixOS/nixpkgs/issues/349572 closes
              # systemd.enableStrictShellChecks = true;
            }
          ]
          # Adds disko configuration if available
          ++ lib.optionals (lib.hasAttr hostName config.flake.diskoConfigurations) [
            inputs.disko.nixosModules.default
            config.flake.diskoConfigurations.${hostName}
          ];
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
