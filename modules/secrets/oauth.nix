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
      }
      // lib.genAttrs' [
        "forgejo"
        "immich"
        "oauth2-proxy"
        "open-webui"
        "opengist"
        "vaultwarden"
        "zipline"
      ] (service: lib.nameValuePair "kanidm/oauth2/${service}" defaults);
  };
}
