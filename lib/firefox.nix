{ lib, util }:
{
  /**
    Takes in a list of search engines to disable

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
    Converts an Attribute Set to firefox
    style compatible settings

    # Example

    ```nix
    toFirefoxSettingStyle { browser.discovery.enabled = false; }
    =>
    { "browser.discovery.enabled" = false; }
    ```

    # Type

    ```
    toFirefoxSettingStyle :: AttrSet -> AttrSet
    ```

    # Arguments

    attrs
    : The attribute set that will be converted
  */
  toFirefoxSettingStyle = attrs: attrs |> util.appendLastWithFullPath |> util.collectLastEntries;
}
