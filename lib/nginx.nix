{ lib }:
{
  /**
    Generate a string with values of the
    Content-Security-Policy http header.

    # Example

    ```nix
    mkCSP { default-src = "none"; }
    =>
    "default-src 'none';"
    ```

    # Type

    ```
    mkCSP :: AttrSet
    ```

    # Arguments

    policyAttr
    : key value pairs of header
  */
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

  /**
    Generate a string with values of the
    Permission-Policy http header.

    # Example

    ```nix
    mkPP { camera = "()"; microphone = "()";}
    =>
    "camera=(), microphone=();"
    ```

    # Type

    ```
    mkPP :: AttrSet
    ```

    # Arguments

    policies
    : key value pairs of header
  */
  mkPP =
    policies:
    policies
    |> lib.mapAttrsToList (directive: value: "${directive}=${value}")
    |> builtins.concatStringsSep ", ";
}
