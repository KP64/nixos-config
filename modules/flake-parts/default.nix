{ inputs, ... }:
{
  imports = with inputs; [
    den.flakeModule
    flake-file.flakeModules.dendritic
  ];

  flake-file = {
    description = "KP64's Overengineered Nix Flake";

    # TODO: Gather all settings from configs
    #       Allows faster first boot with --accept-flake-config
    # nixConfig = {  };

    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      flake-file.url = "github:denful/flake-file";
      den = {
        type = "github";
        owner = "denful";
        repo = "den";
      };
    };
  };
}
