{ inputs }:
let
  inherit (inputs.nixpkgs) lib;

  # -- DESC --
  # Takes in a list of
  # search engines to disable
  hideEngines =
    list:
    lib.genAttrs list (_: {
      metaData.hidden = true;
    });

  # -- DESC --
  # Recurses the attrsets until the name-value-pair is not an attrset
  # Then appends on it the concatenated paths (names)
  # -- CODE --
  # browser.discovery.enabled = false;
  # turns to
  # browser.discovery.enabled."browser.discovery.enabled" = false;
  appendLastWithFullPath =
    attrs:
    lib.mapAttrsRecursiveCond builtins.isAttrs (name: value: {
      ${builtins.concatStringsSep "." name} = value;
    }) attrs;

  # -- DESC --
  # Takes the last entry of each (nested) attrset and
  # collects them into a new set
  # -- CODE --
  # browser.discovery.enabled."browser.discovery.enabled" = false;
  # turns to
  # { "browser.discovery.enabled" = false; }
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
in
{
  inherit appendLastWithFullPath collectLastEntries hideEngines;
}
