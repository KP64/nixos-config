{ lib }:
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
}
