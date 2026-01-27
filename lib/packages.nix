{ lib }:
{
  activatePerHosts =
    { config, list }:
    list
    |> map ({ packages, hosts }: packages |> lib.optionals (builtins.elem config.hostname hosts))
    |> lib.flatten;
}
