{ lib, ... }:
{
  nlib.lib = {
    genUsers = {
      type = with lib.types; functionTo <| listOf attrs;
      fn =
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
      description = ''
        Returns a list of all users and the sops secret
        that is correctly prefixed with "anki/".
      '';
    };
  };
}
