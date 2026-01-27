{ lib }:
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
}
