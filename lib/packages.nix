{ lib }:
{
  /**
    Returns a list of Home-Manager packages
    to include in the corresponding hosts.

    # Example

    ```nix
    activatePerHosts { inherit config; list = [ { package = [ pkgs.manga-tui ]; hosts = [ "aladdin" ]; } ]; }
    =>
    if (config.hostname == "aladdin") then [ pkgs.manga-tui ] else [ ];
    ```

    # Type

    ```
    activatePerHosts :: { config :: Any, list :: [ { packages :: [ package ], hosts :: [ String ] } ] }
    ```

    # Arguments

    config
    : The bare Home-Manager config

    list
    : The list of optional packages and their hosts
  */
  activatePerHosts =
    { config, list }:
    list
    |> map ({ packages, hosts }: packages |> lib.optionals (builtins.elem config.hostname hosts))
    |> lib.flatten;
}
