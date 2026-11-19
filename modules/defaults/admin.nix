{ lib, ... }: {
  den = {
    schema.user.options.isAdmin = lib.mkEnableOption "User is an Admin";

    default.includes = [
      (
        { user, ... }:
        let
          nixSettings.settings.trusted-users = [ user.name ];
        in
        lib.optionalAttrs user.isAdmin {
          user = { config, ... }: {
            isNormalUser = true;
            extraGroups = [ config.users.groups.wheel.name ];
          };

          nixos.nix = nixSettings;

          homeManager =
            {
              nixosConfig ? null,
              ...
            }:
            {
              nix = lib.mkIf (nixosConfig == null) nixSettings;
            };
        }
      )
    ];
  };
}
