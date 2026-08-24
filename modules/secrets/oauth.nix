{ self, ... }: {
  den.aspects.secrets._.oauth.nixos = { config, lib, ... }: {
    sops.secrets =
      let
        unit = config.systemd.services.kanidm.name or [ ];

        defaults = {
          sopsFile = "${self}/secrets/oauth.yaml";
          owner = config.users.users.kanidm.name or null;
          restartUnits = lib.toList unit;
        };
      in
      {
        "kanidm/admin-password" = defaults;
        "kanidm/idm-admin-password" = defaults;
        "kanidm/oauth2/forgejo" = defaults;
        "kanidm/oauth2/open-webui" = defaults;
        "kanidm/oauth2/opengist" = defaults;
        "kanidm/oauth2/zipline" = defaults;
        "kanidm/oauth2/vaultwarden" = defaults;
      };
  };
}
