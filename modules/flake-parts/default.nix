toplevel@{ lib, inputs, ... }:
{
  imports = with inputs; [
    den.flakeModule
    flake-file.flakeModules.dendritic
  ];

  flake-file = {
    description = "KP64's Overengineered Nix Flake";

    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      flake-file.url = "github:denful/flake-file";
      den = {
        type = "github";
        owner = "denful";
        repo = "den";
      };
    };

    nixConfig =
      let
        getSettings =
          includedSettings:
          (with toplevel.config.flake; [
            nixosConfigurations
            homeConfigurations
          ])
          |> map builtins.attrValues
          |> lib.flatten
          |> map (cfg: cfg.config.nix.settings)
          |> map (lib.filterAttrs (setting: _: builtins.elem setting includedSettings))
          |> lib.foldAttrs (
            item: acc:
            if acc == null then
              item
            else if builtins.isBool item && builtins.isBool acc then
              acc || item
            else if builtins.isList item && builtins.isList acc then
              acc ++ item |> lib.unique |> lib.naturalSort
            else if item == acc then
              acc
            else
              throw "Cannot merge values of type ${builtins.typeOf acc} and ${builtins.typeOf item}"
          ) null;
      in
      getSettings [
        "auto-optimise-store"
        "fsync-store-paths"
        "preallocate-contents"
        "sync-before-registering"
        "use-xdg-base-directories"

        "experimental-features"
        "substituters"
        "trusted-public-keys"
        "extra-substituters"
        "extra-trusted-public-keys"

        "lint-absolute-path-literals"
        "lint-short-path-literals"
        "lint-url-literals"
      ];
  };
}
