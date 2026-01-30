{
  config,
  self,
  lib,
  ...
}:
{
  nlib.lib = {
    appendLastWithFullPath = {
      type = with lib.types; functionTo attrs;
      fn =
        attrs:
        attrs
        |> lib.mapAttrsRecursiveCond builtins.isAttrs (
          name: value: { ${builtins.concatStringsSep "." name} = value; }
        );
      description = ''
        Recurses the attrsets until the name-value-pair is not an attrset
        Then appends on it the concatenated paths (names)
      '';
    };

    toFlattenedByDots =
      let
        inherit (config.flake.lib.flake) appendLastWithFullPath collectLastEntries;
      in
      {
        type = with lib.types; functionTo attrs;
        fn = attrs: attrs |> appendLastWithFullPath |> collectLastEntries;
        description = ''
          Converts an Attribute Set to another set
          where each key is separated by a dot.
        '';
      };

    collectLastEntries = {
      type = with lib.types; functionTo attrs;
      fn =
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
      description = ''
        Takes the last entry of each (nested) attrset
        and collects them into a new set
      '';
    };

    getIcon = {
      type = with lib.types; functionTo path;
      fn = { file, type }: builtins.path { path = self + /assets/${type}/${file}; };
      description = ''
        Takes in the type and name of the Icon to get.
      '';
    };

    mapIfAvailable = {
      type = with lib.types; functionTo <| listOf attrs;
      fn =
        {
          needs,
          extraAccess ? [ ],
        }:
        arr:
        arr
        |> lib.filter (builtins.hasAttr needs)
        |> map (conf: conf |> lib.getAttrFromPath ([ needs ] ++ extraAccess));
    };
    description = ''
      Filters an array of attrsets containing the needed
      attribute and maps to subattributes via extraAccess
    '';

    getSopsFiles = {
      type = with lib.types; functionTo <| listOf path;
      fn = secrets: secrets |> builtins.attrValues |> map (secret: secret.sopsFile);
      description = ''
        Gets all files used for sops secrets for the
        passed in configuration.
      '';
    };
  };
}
