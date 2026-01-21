{ lib }:
{
  mkCSP =
    policyAttr:
    policyAttr
    |> lib.mapAttrsToList (
      policy: value:
      let
        processPolicyValue = val: if (lib.hasPrefix "https://" val) then val else "'${val}'";
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
