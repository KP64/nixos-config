toplevel@{ den, ... }:
{
  den.aspects.sheherazade = {
    includes = with den.aspects; [
      acme
      secrets._.oauth
    ];

    nixos =
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
        security.acme.certs.${cfg.server.settings.domain} = { };
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

        services.caddy.virtualHosts.${cfg.server.settings.domain}.extraConfig = # caddy
          ''
            header {
                Cross-Origin-Embedder-Policy require-corp
                Cross-Origin-Opener-Policy same-origin
                Cross-Origin-Resource-Policy same-origin
            }
            reverse_proxy ${cfg.provision.instanceUrl} {
                header_up Host {host}
                transport http {
                    tls_server_name ${cfg.server.settings.domain}
                }
            }
          '';

        # NOTE: Kanidm requires TLS
        services.kanidm = {
          package = pkgs.kanidmWithSecretProvisioning_1_11;

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
              bindaddress = "[::1]:8443";
              origin = "https://${config.services.kanidm.server.settings.domain}";
              domain = "idm.${config.networking.domain}";
              online_backup.versions = 7; # Number of backups
              tls_key = "/run/credentials/${config.systemd.services.kanidm.name}/key.pem";
              tls_chain = "/run/credentials/${config.systemd.services.kanidm.name}/fullchain.pem";
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

                  "oauth2-proxy.access"
                  "oauth2-proxy.navidrome"

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
                groups = [
                  "oauth2-proxy.access"
                  "open-webui.access"
                ];
              };
              jehnsen = {
                displayName = "jehnsen";
                groups = [
                  "forgejo.access"
                  "oauth2-proxy.access"
                ];
              };
              urmom = {
                displayName = "urmom";
                groups = [
                  "forgejo.access"
                  "oauth2-proxy.access"
                  "open-webui.access"
                ];
              };
              vx = {
                displayName = "vx";
                groups = [
                  "forgejo.access"
                  "oauth2-proxy.access"
                  "open-webui.access"
                  "vaultwarden.access"
                  "zipline.access"
                ];
              };
            };

            groups = {
              "forgejo.access" = { };
              "forgejo.admins" = { };

              "oauth2-proxy.access" = { };
              "oauth2-proxy.navidrome" = { };

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
                inherit (toplevel.config.flake.nixosConfigurations) mahdi;
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
                  originUrl = "${mahdi.config.services.forgejo.settings.server.ROOT_URL}/user/oauth2/kanidm/callback";
                  originLanding = "${mahdi.config.services.forgejo.settings.server.ROOT_URL}/user/login";
                  preferShortUsername = true;
                  scopeMaps."forgejo.access" = [
                    "email"
                    "openid"
                    "profile"
                  ];
                };
                oauth2-proxy = {
                  displayName = "oauth2-proxy";
                  imageFile = getAsset {
                    file = "oauth2-proxy.svg";
                    type = "icons";
                    sha256 = "sha256-Nq0y/akf6l+UVsGxgzT6RbrX/uDAqWSQ85rAEF7JSL0=";
                  };
                  basicSecretFile = config.sops.secrets."kanidm/oauth2/oauth2-proxy".path;
                  originUrl = config.services.oauth2-proxy.redirectURL;
                  originLanding = "https://oauth2-proxy.${config.networking.domain}";
                  preferShortUsername = true;
                  scopeMaps."oauth2-proxy.access" = [
                    "email"
                    "profile"
                    "openid"
                  ];
                  claimMaps.groups.valuesByGroup = {
                    "oauth2-proxy.navidrome" = [ "access_navidrome" ];
                  };
                };
                open-webui = {
                  displayName = "open-webui";
                  imageFile = getAsset {
                    file = "open-webui.svg";
                    type = "icons";
                    sha256 = "sha256-gkgmeLLHvvB/QqzfFvh73YOqnyIG8ntknAOgI5NKNqM=";
                  };
                  basicSecretFile = config.sops.secrets."kanidm/oauth2/open-webui".path;
                  originUrl = "${mahdi.config.services.open-webui.environment.WEBUI_URL}/oauth/oidc/callback";
                  originLanding = mahdi.config.services.open-webui.environment.WEBUI_URL;
                  preferShortUsername = true;
                  scopeMaps."open-webui.access" = [
                    "email"
                    "openid"
                    "profile"
                  ];
                  claimMaps = {
                    groups.valuesByGroup."open-webui.admins" = [ "admins" ];
                    roles.valuesByGroup = {
                      "open-webui.admins" = [ "admin" ];
                      "open-webui.access" = [ "user" ];
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
                  originUrl = "${mahdi.config.services.opengist.environment.OG_EXTERNAL_URL}/oauth/openid-connect/callback";
                  originLanding = mahdi.config.services.opengist.environment.OG_EXTERNAL_URL;
                  preferShortUsername = true;
                  scopeMaps."opengist.access" = [
                    "email"
                    "groups"
                    "openid"
                    "profile"
                  ];
                  claimMaps.groups.valuesByGroup."opengist.admins" = [ "admins" ];
                };
                vaultwarden = {
                  displayName = "vaultwarden";
                  imageFile = getAsset {
                    file = "vaultwarden.svg";
                    type = "icons";
                    sha256 = "sha256-25xe1e5fH3h0tW51ALIz3SHTDL3wKmwLdzZDYtQMCZU=";
                  };
                  basicSecretFile = config.sops.secrets."kanidm/oauth2/vaultwarden".path;
                  originUrl = "https://${mahdi.config.services.vaultwarden.domain}/identity/connect/oidc-signin";
                  originLanding = "https://${mahdi.config.services.vaultwarden.domain}";
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
                  originUrl = mahdi.config.services.zipline.settings.OAUTH_OIDC_REDIRECT_URI;
                  originLanding = "https://${mahdi.config.services.zipline.settings.CORE_DEFAULT_DOMAIN}";
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
  };
}
