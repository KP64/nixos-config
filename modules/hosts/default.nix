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
          modules = module.imports ++ [
            inputs.home-manager.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
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
            }
          ];
        };
      }
    );
}
