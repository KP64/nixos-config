{ lib, self }:
{
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

  /**
    Takes in a name of an icon and returns its path

    # Example

    ```nix
    mkIcon "open-webui"
    =>
    "${self}/assets/icons/open-webui.svg"
    ```

    # Type

    ```
    mkIcon :: String -> Path
    ```

    # Arguments

    iconName
    : The name of the icon (duh)
  */
  mkIcon = iconName: builtins.path { path = self + /assets/icons/${iconName}.svg; };

  /**
    Filters an array of attrsets containing the needed
    attribute and maps to subattributes via extraAccess

    # Example

    ```nix
    mapIfAvailable { needs = "sops" } [ { config.sops."wireless.env" = { }; } ]
    =>
    [ { sops = { "wireless.env" = { ... }; ... }; } { ... } ]
    ```

    # Type

    ```
    mapIfAvailable :: { needs :: String; extraAccess :: [ String ]; } -> [ AttrSet ]
    ```
  */
  mapIfAvailable =
    {
      needs,
      extraAccess ? [ ],
    }:
    arr:
    arr
    |> lib.filter (builtins.hasAttr needs)
    |> map (conf: conf |> lib.getAttrFromPath ([ needs ] ++ extraAccess));

  /**
    Gets all files used for sops secrets for the
    passed in configuration.

    # Example

    ```nix
    getSopsFiles config.sops.secrets
    =>
    [ "/nix/store/.../modules/users/kg/secrets.yaml" ]
    ```

    # Type

    ```
    getSopsFiles :: AttrSet -> [ Path ]
    ```

    # Arguments

    secrets
    : The secrets of the host or user
  */
  getSopsFiles = secrets: secrets |> builtins.attrValues |> map (secret: secret.sopsFile);
}
