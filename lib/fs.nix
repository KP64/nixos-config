{ lib }:
{
  /**
    This function returns a list with
    the names of all directories and all
    files with the ".nix" extension.
    The default.nix of the specified path
    will always be ignored.
    The flake.nix is excluded by default too
    but can be included by setting excludeFlake to false.

    # Example

    ```nix
    scanPath { path = "${self}/hosts/nixos/aladdin"; }
    =>
    [
      "default.nix"
      "disko-config.nix"
    ]
    ```

    # Type

    ```
    scanPath :: AttrSet -> [ String ]
    ```

    # Arguments

    path
    : The path to be scanned
  */
  scanPath =
    {
      path,
      excludeFlake ? true,
    }:
    path
    |> builtins.readDir
    |> lib.filterAttrs (
      path: type:
      type == "directory"
      || (
        path != "default.nix"
        |> lib.and (excludeFlake -> path != "flake.nix")
        |> lib.and (lib.hasSuffix ".nix" path)
      )
    )
    |> builtins.attrNames
    |> map (f: "${path}/${f}");
}
