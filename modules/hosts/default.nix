{
  lib,
  config,
  inputs,
  ...
}:
let
  prefix = "hosts/";
in
{
  flake.nixosConfigurations =
    config.flake.modules.nixos
    |> lib.filterAttrs (name: _: name |> lib.hasPrefix prefix)
    |> lib.mapAttrs' (
      name: module: {
        name = name |> lib.removePrefix prefix;
        value = inputs.nixpkgs.lib.nixosSystem { modules = module.imports; };
      }
    );
}
