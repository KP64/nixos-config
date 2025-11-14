{ lib }:
{
  /**
    Returns a list of all users and the sops secret
    that is correctly prefixed with "anki/".

    # Example

    ```nix
    genUsers config.sops.secrets
    =>
    [ { username = "kg"; passwordFile = config.sops.secrets."anki/kg".path; } ]
    ```

    # Type

    ```
    genUsers :: AttrSet -> [ { username :: String; passwordFile :: Path } ]
    ```

    # Arguments

    secrets
    : The sops secrets
  */
  genUsers =
    secrets:
    let
      prefix = "anki/";
    in
    secrets
    |> lib.filterAttrs (name: _: lib.hasPrefix prefix name)
    |> lib.mapAttrsToList (
      name: secret: {
        username = lib.removePrefix prefix name;
        passwordFile = secret.path;
      }
    );
}
