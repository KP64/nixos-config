{
  den.aspects.customLib.nixos =
    { config, lib, ... }:
    {
      nix-lib.lib.hm = {
        anyHmUser = {
          type = with lib.types; functionTo bool;
          fn = cond: config.home-manager.users |> builtins.attrValues |> builtins.any cond;
          description = ''
            A function returning a boolean if any of the
            home manager users satisfied the passed in condition.
          '';
        };
      };
    };
}
