toplevel: {
  den.aspects.mahdi.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.kanidm;
    in
    {
      sops.secrets =
        let
          owner = config.users.users.kanidm.name;
          restartUnits = [ config.systemd.services.kanidm.name ];
        in
        {
          "kanidm/admin-password" = { inherit owner restartUnits; };
          "kanidm/idm-admin-password" = { inherit owner restartUnits; };
          "kanidm/oauth2/forgejo" = { inherit owner restartUnits; };
          "kanidm/oauth2/karakeep" = { inherit owner restartUnits; };
          "kanidm/oauth2/open-webui" = { inherit owner restartUnits; };
          "kanidm/oauth2/opengist" = { inherit owner restartUnits; };
          "kanidm/oauth2/zipline" = { inherit owner restartUnits; };
          "kanidm/oauth2/vaultwarden" = { inherit owner restartUnits; };
        };

      services.nginx.virtualHosts.${cfg.server.settings.domain} = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/".proxyPass = cfg.provision.instanceUrl;
      };

      systemd.services.kanidm = {
        wants = [ "acme-${cfg.server.settings.domain}.service" ];
        after = [ "acme-${cfg.server.settings.domain}.service" ];
        serviceConfig.LoadCredential =
          map (cred: "${cred}:${config.security.acme.certs.${cfg.server.settings.domain}.directory}/${cred}")
            [
              "key.pem"
              "fullchain.pem"
            ];
      };

      # NOTE: Kanidm requires TLS
      services.kanidm = {
        package = pkgs.kanidmWithSecretProvisioning_1_10;

        client = {
          enable = true;
          settings = {
            uri = config.services.kanidm.server.settings.origin;
            verify_ca = true;
            verify_hostnames = true;
          };
        };

        server = {
          enable = true;
          settings = {
            origin = "https://${config.services.kanidm.server.settings.domain}";
            domain = "idm.${config.networking.domain}";
            online_backup.versions = 7; # Number of backups
            tls_key = "/run/credentials/kanidm.service/key.pem";
            tls_chain = "/run/credentials/kanidm.service/fullchain.pem";
          };
        };
        provision = {
          enable = true;

          adminPasswordFile = config.sops.secrets."kanidm/admin-password".path;
          idmAdminPasswordFile = config.sops.secrets."kanidm/idm-admin-password".path;

          persons = lib.recursiveUpdate config.invisible.kanidm.persons {
            kg = {
              displayName = "kg";
              groups = [
                "forgejo.access"
                "forgejo.admins"

                "karakeep.access"
                "karakeep.admins"

                "komga.access"
                "komga.admins"

                "open-webui.access"
                "open-webui.admins"

                "opengist.access"
                "opengist.admins"

                "vaultwarden.access"
                "vaultwarden.admins"

                "zipline.access"
                "zipline.admins"
              ];
            };
            ja = {
              displayName = "ja";
              groups = [ "open-webui.access" ];
            };
            jehnsen = {
              displayName = "jehnsen";
              groups = [ "forgejo.access" ];
            };
            urmom = {
              displayName = "urmom";
              groups = [
                "forgejo.access"
                "open-webui.access"
              ];
            };
            vx = {
              displayName = "vx";
              groups = [
                "forgejo.access"
                "open-webui.access"
                "vaultwarden.access"
                "zipline.access"
              ];
            };
          };

          groups = {
            "forgejo.access" = { };
            "forgejo.admins" = { };

            "karakeep.access" = { };
            "karakeep.admins" = { };

            "komga.access" = { };
            "komga.admins" = { };

            "open-webui.access" = { };
            "open-webui.admins" = { };

            "opengist.access" = { };
            "opengist.admins" = { };

            "vaultwarden.access" = { };
            "vaultwarden.admins" = { };

            "zipline.access" = { };
            "zipline.admins" = { };
          };

          systems.oauth2 =
            let
              inherit (toplevel.config.lib.flake.util) getAsset;
            in
            {
              forgejo = {
                displayName = "forgejo";
                imageFile = getAsset {
                  file = "forgejo.svg";
                  type = "icons";
                  sha256 = "sha256-OIP5UvHrWweyDQqNtDILGKvWTJQ2BxaiyRDbYzRTawg=";
                };
                basicSecretFile = config.sops.secrets."kanidm/oauth2/forgejo".path;
                originUrl = "${config.services.forgejo.settings.server.ROOT_URL}/user/oauth2/kanidm/callback";
                originLanding = "${config.services.forgejo.settings.server.ROOT_URL}/user/login";
                preferShortUsername = true;
                scopeMaps."forgejo.access" = [
                  "email"
                  "openid"
                  "profile"
                ];
              };
              karakeep = {
                displayName = "karakeep";
                imageFile = getAsset {
                  file = "karakeep.svg";
                  type = "icons";
                  sha256 = "sha256-9MYbNA8a+/mKS3gut3xEJV5TPBtmXcE7Fo3mfx7F76U=";
                };
                basicSecretFile = config.sops.secrets."kanidm/oauth2/karakeep".path;
                enableLegacyCrypto = true; # Needed because karakeep doesn't support ES256
                originUrl = "${config.services.karakeep.extraEnvironment.NEXTAUTH_URL}/api/auth/callback/custom";
                originLanding = config.services.karakeep.extraEnvironment.NEXTAUTH_URL;
                preferShortUsername = true;
                scopeMaps."karakeep.access" = [
                  "email"
                  "openid"
                  "profile"
                ];
              };
              komga = {
                displayName = "komga";
                imageFile = getAsset {
                  file = "komga.svg";
                  type = "icons";
                  sha256 = "sha256-g9YjBj9+I6Uor4FRDiuQlygs7DkVWVmbjdtdLx87Pok=";
                };
                public = true;
                enableLegacyCrypto = true;
                originUrl = "https://komga.${config.networking.domain}/login/oauth2/code/${config.services.komga.settings.spring.security.oauth2.client.registration.kanidm.provider}";
                originLanding = "https://komga.${config.networking.domain}";
                preferShortUsername = true;
                scopeMaps."komga.access" = [
                  "email"
                  "openid"
                ];
              };
              open-webui = {
                displayName = "open-webui";
                imageFile = getAsset {
                  file = "open-webui.svg";
                  type = "icons";
                  sha256 = "sha256-gkgmeLLHvvB/QqzfFvh73YOqnyIG8ntknAOgI5NKNqM=";
                };
                basicSecretFile = config.sops.secrets."kanidm/oauth2/open-webui".path;
                originUrl = "${config.services.open-webui.environment.WEBUI_URL}/oauth/oidc/callback";
                originLanding = config.services.open-webui.environment.WEBUI_URL;
                preferShortUsername = true;
                scopeMaps."open-webui.access" = [
                  "email"
                  "openid"
                  "profile"
                ];
                claimMaps = {
                  groups = {
                    joinType = "array";
                    valuesByGroup."open-webui.admins" = [ "admins" ];
                  };
                  roles = {
                    joinType = "array";
                    valuesByGroup = {
                      "open-webui.admins" = [ "admin" ];
                      "open-webui.access" = [ "user" ];
                    };
                  };
                };
              };
              opengist = {
                displayName = "opengist";
                imageFile = getAsset {
                  file = "opengist.svg";
                  type = "icons";
                  sha256 = "sha256-5BzhYqlg1OK1T+kPRtwH8KV0e5obj/jm3DLb+Cgl150=";
                };
                basicSecretFile = config.sops.secrets."kanidm/oauth2/opengist".path;
                originUrl = "${config.services.opengist.environment.OG_EXTERNAL_URL}/oauth/openid-connect/callback";
                originLanding = config.services.opengist.environment.OG_EXTERNAL_URL;
                preferShortUsername = true;
                scopeMaps."opengist.access" = [
                  "email"
                  "groups"
                  "openid"
                  "profile"
                ];
              };
              vaultwarden = {
                displayName = "vaultwarden";
                imageFile = getAsset {
                  file = "vaultwarden.svg";
                  type = "icons";
                  sha256 = "sha256-25xe1e5fH3h0tW51ALIz3SHTDL3wKmwLdzZDYtQMCZU=";
                };
                basicSecretFile = config.sops.secrets."kanidm/oauth2/vaultwarden".path;
                originUrl = "https://${config.services.vaultwarden.domain}/identity/connect/oidc-signin";
                originLanding = "https://${config.services.vaultwarden.domain}";
                preferShortUsername = true;
                scopeMaps."vaultwarden.access" = [
                  "email"
                  "openid"
                  "profile"
                ];
              };
              zipline = {
                displayName = "zipline";
                imageFile = getAsset {
                  file = "zipline.svg";
                  type = "icons";
                  sha256 = "sha256-fupvhvO/kr/8VuN07uHlp1UuCxLx4QlAb63wqn5somI=";
                };
                basicSecretFile = config.sops.secrets."kanidm/oauth2/zipline".path;
                originUrl = config.services.zipline.settings.OAUTH_OIDC_REDIRECT_URI;
                originLanding = "https://${config.services.zipline.settings.CORE_DEFAULT_DOMAIN}";
                preferShortUsername = true;
                scopeMaps."zipline.access" = [
                  "email"
                  "offline_access"
                  "openid"
                  "profile"
                ];
              };
            };
        };
      };
    };
}
