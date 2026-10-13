toplevel@{ den, ... }:
{
  den = {
    schema.user.options.isAdmin = toplevel.lib.mkEnableOption "User is an Admin";

    default.includes = [ den.aspects.admin ];
    aspects.admin =
      { user, lib, ... }:
      lib.optionalAttrs user.isAdmin {
        nixos = { config, ... }: {
          nix.settings.trusted-users = [ user.name ];
          users.users.${user.name} = {
            isNormalUser = true;
            extraGroups = [ config.users.groups.wheel.name ];
          };
        };

        homeManager =
          {
            nixosConfig ? null,
            lib,
            ...
          }:
          {
            nix = lib.mkIf (nixosConfig == null) { settings.trusted-users = [ user.name ]; };
          };
      };
  };
}
