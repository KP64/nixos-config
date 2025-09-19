{
  config,
  lib,
  inputs,
  customLib,
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
                extraSpecialArgs = { inherit inputs customLib; };
              };
            }
            {
              users.mutableUsers = false;
              environment.defaultPackages = [ ];
              boot.tmp.cleanOnBoot = true;
              networking = { inherit hostName; };
            }
          ];
        };
      }
    );
}
