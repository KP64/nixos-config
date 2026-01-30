{ lib, ... }:
{
  nlib.lib = {
    activatePerHosts = {
      type = with lib.types; functionTo <| listOf package;
      fn =
        { config, list }:
        list
        |> map ({ packages, hosts }: packages |> lib.optionals (builtins.elem config.hostname hosts))
        |> lib.flatten;
      description = ''
        Returns a list of Home-Manager packages
        to include in the corresponding hosts.
      '';
    };
  };
}
