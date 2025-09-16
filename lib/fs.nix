{ lib }:
{
  /**
    This function returns a list with
    the names of all directories and all
    files with the ".nix" extension except
    for default.nix of the specified path

    # Example

    ```nix
    scanPath "${self}/hosts/nixos/aladdin"
    =>
    [
      "default.nix"
      "disko-config.nix"
    ]
    ```

    # Type

    ```
    scanPath :: Path -> [ String ]
    ```

    # Arguments

    path
    : The path to be scanned
  */
  scanPath =
    path:
    path
    |> builtins.readDir
    |> lib.filterAttrs (
      path: type: (type == "directory") || (path != "default.nix" && lib.hasSuffix ".nix" path)
    )
    |> builtins.attrNames
    |> map (f: "${path}/${f}");
}
