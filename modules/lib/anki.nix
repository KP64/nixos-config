{
  flake.modules.nixos.customLib =
    { config, lib, ... }:
    {
      nix-lib.lib.anki = {
        genUsers = {
          type = with lib.types; listOf <| attrsOf anything;
          fn =
            let
              prefix = "anki/";
            in
            config.sops.secrets
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
    };
}
