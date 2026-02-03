{
  perSystem =
    { pkgs, lib, ... }:
    {
      nix-lib.lib.minecraft = {
        collectMods = {
          type = with lib.types; functionTo package;
          fn = mods: mods |> builtins.attrValues |> map pkgs.fetchurl |> pkgs.linkFarmFromDrvs "mods";
          description = "Takes in an Attribute of mods and generates a derivation out of them.";
        };
      };
    };
}
