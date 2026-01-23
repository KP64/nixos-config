{ lib }:
{
  mkCSP =
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

  mkPP =
    policies:
    policies
    |> lib.mapAttrsToList (directive: value: "${directive}=${value}")
    |> builtins.concatStringsSep ", ";
}
