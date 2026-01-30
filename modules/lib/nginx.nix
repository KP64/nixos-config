{ lib, ... }:
{
  nlib.lib = {
    mkCSP = {
      type = with lib.types; functionTo nonEmptyStr;
      fn =
        policyAttr:
        policyAttr
        |> lib.mapAttrsToList (
          policy: value:
          let
            prefixes = [
              "https:"
              "data:"
            ];
            processPolicyValue =
              val: if (builtins.any (prefix: lib.hasPrefix prefix val) prefixes) then val else "'${val}'";
            pv =
              if (builtins.isList value) then
                value |> lib.concatMapStringsSep " " processPolicyValue
              else
                processPolicyValue value;
          in
          "${policy} ${pv};"
        )
        |> builtins.concatStringsSep " ";
      description = ''
        Generate a string with values of the
        Content-Security-Policy http header.
      '';
    };

    mkPP = {
      type = with lib.types; functionTo nonEmptyStr;
      fn =
        policies:
        policies
        |> lib.mapAttrsToList (directive: value: "${directive}=${value}")
        |> builtins.concatStringsSep ", ";
      description = ''
        Generate a string with values of the
        Permission-Policy http header.
      '';
    };
  };
}
