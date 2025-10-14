{ lib }:
{
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
