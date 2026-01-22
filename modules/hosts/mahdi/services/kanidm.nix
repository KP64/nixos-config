{ customLib, inputs, ... }:
{
  flake.modules.nixos.hosts-mahdi =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      invisible = import (inputs.nix-invisible + /hosts/${config.networking.hostName}.nix);
    in
    {
      services.nginx.virtualHosts.${config.services.kanidm.serverSettings.domain} = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/".proxyPass = config.services.kanidm.provision.instanceUrl;
      };

      sops.secrets =
        let
          owner = config.users.users.kanidm.name;
        in
        {
          "kanidm/admin-password" = { inherit owner; };
          "kanidm/idm-admin-password" = { inherit owner; };
          "kanidm/oauth2/coder" = { inherit owner; };
          "kanidm/oauth2/zipline" = { inherit owner; };
        };

      # TODO: Kanidm shouldn't have access to everything nginx related
      #        - Use different Cert between Nginx and Kanidm
      users.users.kanidm.extraGroups = [ "nginx" ];

      # Kanidm requires TLS
      services.kanidm =
        let
          certDir = config.security.acme.certs.${config.services.kanidm.serverSettings.domain}.directory;
        in
        {
          package = pkgs.kanidmWithSecretProvisioning_1_8;
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

                  "immich.access"
                  "immich.admins"

                  "karakeep.access"
                  "karakeep.admins"

                  "komga.access"
                  "komga.admins"

                  "open-webui.access"
                  "open-webui.admins"

                  "vaultwarden.access"
                  "vaultwarden.admins"

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
                  "open-webui.access"
                ];
              };
              vx = {
                displayName = "vx";
                groups = [
                  "coder.access"
                  "forgejo.access"
                  "open-webui.access"
                  "vaultwarden.access"
                  "zipline.access"
                ];
              };
            };

            groups = {
              "coder.access" = { };
              "coder.admins" = { };

              "forgejo.access" = { };
              "forgejo.admins" = { };

              "immich.access" = { };
              "immich.admins" = { };

              "karakeep.access" = { };
              "karakeep.admins" = { };

              "komga.access" = { };
              "komga.admins" = { };

              "open-webui.access" = { };
              "open-webui.admins" = { };

              "vaultwarden.access" = { };
              "vaultwarden.admins" = { };

              "zipline.access" = { };
              "zipline.admins" = { };
            };

            systems.oauth2 =
              let
                inherit (customLib.util) getIcon;
              in
              {
                vaultwarden = {
                  displayName = "vaultwarden";
                  imageFile = getIcon {
                    file = "vaultwarden.svg";
                    type = "icons";
                  };
                  public = true;
                  originUrl = "https://${config.services.vaultwarden.domain}/identity/connect/oidc-signin";
                  originLanding = "https://${config.services.vaultwarden.domain}";
                  preferShortUsername = true;
                  scopeMaps."vaultwarden.access" = [
                    "email"
                    "openid"
                    "profile"
                  ];
                };
                coder = {
                  displayName = "coder";
                  imageFile = getIcon {
                    file = "coder.svg";
                    type = "icons";
                  };
                  basicSecretFile = config.sops.secrets."kanidm/oauth2/coder".path;
                  allowInsecureClientDisablePkce = true;
                  originUrl = "${config.services.coder.accessUrl}/api/v2/users/oidc/callback";
                  originLanding = config.services.coder.accessUrl;
                  preferShortUsername = true;
                  scopeMaps."coder.access" = [
                    "email"
                    "openid"
                    "profile"
                  ];
                };
                forgejo = {
                  displayName = "forgejo";
                  imageFile = getIcon {
                    file = "forgejo.svg";
                    type = "icons";
                  };
                  public = true;
                  originUrl = "${config.services.forgejo.settings.server.ROOT_URL}/user/oauth2/kanidm/callback";
                  originLanding = "${config.services.forgejo.settings.server.ROOT_URL}/user/login";
                  preferShortUsername = true;
                  scopeMaps."forgejo.access" = [
                    "email"
                    "openid"
                    "profile"
                  ];
                  # TODO: Enable claimMaps in forgejo
                  claimMaps.groups = {
                    joinType = "array";
                    valuesByGroup = {
                      "forgejo.admins" = [ "admins" ];
                      "forgejo.access" = [ "users" ];
                    };
                  };
                };
                karakeep = {
                  displayName = "karakeep";
                  imageFile = getIcon {
                    file = "karakeep.svg";
                    type = "icons";
                  };
                  public = true;
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
                open-webui = {
                  displayName = "open-webui";
                  imageFile = getIcon {
                    file = "open-webui.svg";
                    type = "icons";
                  };
                  public = true;
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
                zipline = {
                  displayName = "zipline";
                  imageFile = getIcon {
                    file = "zipline.svg";
                    type = "icons";
                  };
                  basicSecretFile = config.sops.secrets."kanidm/oauth2/zipline".path;
                  allowInsecureClientDisablePkce = true;
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
                komga = {
                  displayName = "komga";
                  imageFile = getIcon {
                    file = "komga.svg";
                    type = "icons";
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
                immich = {
                  displayName = "immich";
                  imageFile = getIcon {
                    file = "immich.svg";
                    type = "icons";
                  };
                  public = true;
                  originUrl = [
                    "https://immich.${config.networking.domain}/auth/login"
                    "app.immich:///oauth-callback" # For mobile app
                  ];
                  originLanding = "https://immich.${config.networking.domain}";
                  preferShortUsername = true;
                  scopeMaps."immich.access" = [
                    "email"
                    "openid"
                    "profile"
                  ];
                  claimMaps.roles = {
                    joinType = "array";
                    valuesByGroup = {
                      "immich.admins" = [ "admin" ];
                      "immich.access" = [ "user" ];
                    };
                  };
                };
              };
          };
        };
    };
}
