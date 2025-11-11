{ inputs, ... }:
{
  flake.modules.nixos.hosts-mahdi =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      kanidmDomain = config.services.kanidm.serverSettings.domain;
      invisible = import (inputs.nix-invisible + /hosts/${config.networking.hostName}.nix);
    in
    {
      services.nginx.virtualHosts.${kanidmDomain} = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/".proxyPass = config.services.kanidm.provision.instanceUrl;
      };

      sops.secrets =
        let
          defaults = {
            owner = "kanidm";
            group = "kanidm";
          };
        in
        {
          "kanidm/admin-password" = defaults;
          "kanidm/idm-admin-password" = defaults;
          "kanidm/oauth2/coder" = defaults;
          "kanidm/oauth2/stirling-pdf" = defaults;
          "kanidm/oauth2/zipline" = defaults;
        };

      # TODO: Kanidm shouldn't have access to everything nginx related
      #        - Use different Cert between Nginx and Kanidm
      users.users.kanidm.extraGroups = [ "nginx" ];

      # Kanidm requires TLS
      services.kanidm =
        let
          certDir = config.security.acme.certs.${kanidmDomain}.directory;
        in
        {
          package = pkgs.kanidmWithSecretProvisioning_1_7;
          enableServer = true;

          enableClient = true;
          clientSettings.uri = config.services.kanidm.serverSettings.origin;

          serverSettings = {
            origin = "https://${config.services.kanidm.serverSettings.domain}";
            domain = "idm.${config.networking.domain}";
            online_backup.versions = 7; # Number of backups
            tls_key = "${certDir}/key.pem";
            tls_chain = "${certDir}/fullchain.pem";
          };
          provision = {
            enable = true;

            adminPasswordFile = config.sops.secrets."kanidm/admin-password".path;
            idmAdminPasswordFile = config.sops.secrets."kanidm/idm-admin-password".path;

            persons = lib.recursiveUpdate invisible.kanidm.persons {
              kg = {
                displayName = "kg";
                groups = [
                  "coder.access"
                  "coder.admins"

                  "forgejo.access"
                  "forgejo.admins"

                  "karakeep.access"
                  "karakeep.admins"

                  "open-webui.access"
                  "open-webui.admins"

                  "stirling-pdf.access"
                  "stirling-pdf.admins"

                  "zipline.access"
                  "zipline.admins"
                ];
              };
              jehnsen = {
                displayName = "jehnsen";
                groups = [
                  "coder.access"
                  "forgejo.access"
                ];
              };
              jodada = {
                displayName = "jodada";
                groups = [ "forgejo.access" ];
              };
              urmom = {
                displayName = "urmom";
                groups = [
                  "coder.access"
                  "forgejo.access"
                ];
              };
            };

            groups = {
              "coder.access" = { };
              "coder.admins" = { };

              "forgejo.access" = { };
              "forgejo.admins" = { };

              "karakeep.access" = { };
              "karakeep.admins" = { };

              "open-webui.access" = { };
              "open-webui.admins" = { };

              "stirling-pdf.access" = { };
              "stirling-pdf.admins" = { };

              "zipline.access" = { };
              "zipline.admins" = { };
            };

            systems.oauth2 = {
              coder = {
                displayName = "coder";
                imageFile = builtins.path { path = inputs.self + /assets/coder.svg; };
                basicSecretFile = config.sops.secrets."kanidm/oauth2/coder".path;
                allowInsecureClientDisablePkce = true;
                originUrl = "https://coder.${config.networking.domain}/api/v2/users/oidc/callback";
                originLanding = "https://coder.${config.networking.domain}";
                preferShortUsername = true;
                scopeMaps."coder.access" = [
                  "email"
                  "openid"
                  "profile"
                ];
                claimMaps.groups = {
                  joinType = "array";
                  valuesByGroup."coder.admins" = [ "admins" ];
                };
              };
              forgejo = {
                displayName = "forgejo";
                imageFile = builtins.path { path = inputs.self + /assets/forgejo.svg; };
                public = true;
                originUrl = "https://${config.services.forgejo.settings.server.DOMAIN}/user/oauth2/kanidm/callback";
                originLanding = "https://${config.services.forgejo.settings.server.DOMAIN}/user/login";
                preferShortUsername = true;
                scopeMaps."forgejo.access" = [
                  "email"
                  "openid"
                  "profile"
                ];
                claimMaps.groups = {
                  joinType = "array";
                  valuesByGroup."forgejo.admins" = [ "admins" ];
                };
              };
              karakeep = {
                displayName = "karakeep";
                imageFile = builtins.path { path = inputs.self + /assets/karakeep.svg; };
                public = true;
                enableLegacyCrypto = true; # Needed because karakeep doesn't support ES256
                originUrl = "${config.services.karakeep.extraEnvironment.NEXTAUTH_URL}/api/auth/callback/custom";
                originLanding = "https://karakeep.${config.networking.domain}";
                preferShortUsername = true;
                scopeMaps."karakeep.access" = [
                  "email"
                  "openid"
                  "profile"
                ];
                claimMaps.groups = {
                  joinType = "array";
                  valuesByGroup."karakeep.admins" = [ "admins" ];
                };
              };
              open-webui = {
                displayName = "open-webui";
                imageFile = builtins.path { path = inputs.self + /assets/open-webui.svg; };
                public = true;
                originUrl = "${config.services.open-webui.environment.WEBUI_URL}/oauth/oidc/callback";
                originLanding = "${config.services.open-webui.environment.WEBUI_URL}/auth";
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
              # Uhmmmm Stirling... Why are you that insecure? XD
              stirling-pdf = {
                displayName = "stirling-pdf";
                imageFile = builtins.path { path = inputs.self + /assets/stirling-pdf.svg; };
                basicSecretFile = config.sops.secrets."kanidm/oauth2/stirling-pdf".path;
                allowInsecureClientDisablePkce = true;
                enableLegacyCrypto = true; # Needed because Stirling apparently doesn't support ES256
                originUrl = "https://stirling-pdf.${config.networking.domain}/login/oauth2/code/oidc";
                originLanding = "https://stirling-pdf.${config.networking.domain}";
                preferShortUsername = true;
                scopeMaps."stirling-pdf.access" = [
                  "email"
                  "openid"
                  "profile"
                ];
                claimMaps.groups = {
                  joinType = "array";
                  valuesByGroup."stirling-pdf.admins" = [ "admins" ];
                };
              };
              zipline = {
                displayName = "zipline";
                imageFile = builtins.path { path = inputs.self + /assets/zipline.svg; };
                basicSecretFile = config.sops.secrets."kanidm/oauth2/zipline".path;
                allowInsecureClientDisablePkce = true;
                originUrl = config.services.zipline.settings.OAUTH_OIDC_REDIRECT_URI;
                originLanding = "https://zipline.${config.networking.domain}";
                preferShortUsername = true;
                scopeMaps."zipline.access" = [
                  "email"
                  "offline_access"
                  "openid"
                  "profile"
                ];
                claimMaps.groups = {
                  joinType = "array";
                  valuesByGroup."zipline.admins" = [ "admins" ];
                };
              };
            };
          };
        };
    };
}
