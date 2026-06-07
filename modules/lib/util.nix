{ self, lib, ... }: {
  nix-lib.lib.util = {
    toFlattenedByDots = {
      type = with lib.types; functionTo (attrsOf anything);
      fn =
        attrs:
        let
          flatten =
            prefix: attrs:
            lib.foldlAttrs (
              acc: name: value:
              let
                key = if prefix == "" then name else "${prefix}.${name}";
              in
              acc // (if builtins.isAttrs value then flatten key value else { ${key} = value; })
            ) { } attrs;
        in
        flatten "" attrs;
      description = ''
        Converts an Attribute Set to another set
        where each key is separated by a dot.
      '';
    };

    getAsset = {
      type = with lib.types; functionTo path;
      fn =
        {
          file,
          type,
          sha256,
        }:
        builtins.path {
          name = "asset-${file}";
          path = "${self}/assets/${type}/${file}";
          recursive = false;
          inherit sha256;
        };
      description = ''
        Takes in the type and name of the Icon to get.
      '';
    };

    mapIfAvailable = {
      type = with lib.types; functionTo <| listOf <| attrsOf anything;
      fn =
        {
          needs,
          extraAccess ? [ ],
        }:
        arr:
        arr |> lib.filter (builtins.hasAttr needs) |> map (lib.getAttrFromPath ([ needs ] ++ extraAccess));
      description = ''
        Filters an array of attrsets containing the needed
        attribute and maps to subattributes via extraAccess
      '';
    };
  };
}
