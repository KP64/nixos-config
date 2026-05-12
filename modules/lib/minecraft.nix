{
  flake-file.inputs.nix-minecraft = {
    type = "github";
    owner = "Infinidoge";
    repo = "nix-minecraft";
    inputs = {
      flake-compat.follows = "";
      nixpkgs.follows = "nixpkgs";
    };
  };

  perSystem =
    { pkgs, lib, ... }:
    {
      nix-lib.lib.minecraft = {
        collectMods = {
          type = with lib.types; functionTo package;
          fn = mods: mods |> builtins.attrValues |> map pkgs.fetchurl |> pkgs.linkFarmFromDrvs "mods";
          description = "Converts an Attrset to a derivation of mods";
        };
      };
    };
}
