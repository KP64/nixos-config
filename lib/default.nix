{ inputs }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  /**
    This function returns a list with
    the names of all directories and all
    files with the ".nix" extension except
    for default.nix of the specified path

    # Example

    ```nix
    scanPath "${inputs.self}/hosts/nixos/aladdin"
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

  importUsers = userList: userList |> map (user: "${inputs.self}/users/${user}/nixos.nix");

  importHomes =
    userList:
    userList
    |> map (user: {
      home-manager.users.${user} = lib.mkMerge [
        "${inputs.self}/users/${user}/home.nix"
        {
          programs.home-manager.enable = true;
          home = {
            username = user;
            homeDirectory = "/home/${user}";
          };
        }
      ];
    });

  /**
    Takes in a list of search
    engines to disable

    # Example

    ```nix
    hideEngines [ "bing" ]
    =>
    { "bing" = { metaData.hidden = true; }; }
    ```

    # Type

    ```
    hideEngines :: [ String ] -> AttrSet
    ```

    # Arguments

    list
    : The list of engine names to be disabled
  */
  hideEngines =
    list:
    lib.genAttrs list (_: {
      metaData.hidden = true;
    });

  /**
    Recurses the attrsets until the name-value-pair is not an attrset
    Then appends on it the concatenated paths (names)

    # Example

    ```nix
    appendLastWithFullPath { browser.discovery.enabled = false; }
    =>
    { browser.discovery.enabled."browser.discovery.enabled" = false; }

    # Type

    ```
    appendLastWithFullPath :: AttrSet -> AttrSet
    ```

    # Arguments

    attrs
    : The attribute set to whose keys will be "appended"
  */
  appendLastWithFullPath =
    attrs:
    attrs
    |> lib.mapAttrsRecursiveCond builtins.isAttrs (
      name: value: { ${builtins.concatStringsSep "." name} = value; }
    );

  /**
    Takes the last entry of each (nested) attrset
    and collects them into a new set

    # Example

    ```nix
    collectLastEntries { browser.discovery.enabled."browser.discovery.enabled" = false; }
    =>
    { "browser.discovery.enabled" = false; }
    ```

    # Type

    ```
    collectLastEntries :: AttrSet -> AttrSet
    ```

    # Arguments

    attrs
    : The attribute set whose last keys will be collected
  */
  collectLastEntries =
    attrs:
    rec {
      flatten =
        set:
        let
          processAttr = name: value: if builtins.isAttrs value then flatten value else { "${name}" = value; };
        in
        lib.foldlAttrs (
          acc: name: value:
          acc // processAttr name value
        ) { } set;

      result = flatten attrs;
    }
    .result;
}
