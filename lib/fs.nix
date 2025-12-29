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
    scanPath { p = "${self}/modules/hosts/aladdin"; }
    =>
    [
      "default.nix"
      "networking.nix"
      "services/"
    ]
    ```

    # Type

    ```
    scanPath :: AttrSet -> [ String ]
    ```

    # Arguments

    p
    : The path to be scanned
  */
  scanPath =
    {
      p,
      excludeFlake ? true,
    }:
    p
    |> builtins.readDir
    |> lib.filterAttrs (
      p: type:
      type == "directory"
      || (p != "default.nix" && (excludeFlake -> p != "flake.nix") && lib.hasSuffix ".nix" p)
    )
    |> builtins.attrNames
    |> map (f: "${p}/${f}");
}
