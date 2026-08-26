{ den, ... }: {
  den.aspects.mahdi = {
    includes = [ den.aspects.virtualisation._.podman ];

    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        inherit (config.lib.securityHeader) mkCSP mkPP;
      in
      lib.mkMerge [
        (lib.mkIf config.services.forgejo.enable {
          sops.secrets."forgejo/runners/runner/default-connection" = { };

          networking.firewall.allowedTCPPorts = [ config.services.forgejo.settings.server.SSH_PORT ];

          services = {
            nginx.virtualHosts.${config.services.forgejo.settings.server.DOMAIN} = {
              enableACME = true;
              acmeRoot = null;
              onlySSL = true;
              kTLS = true;
              extraConfig = # nginx
                ''
                  client_max_body_size 512M;
                '';
              locations."/" = {
                proxyPass = "http://unix:${config.services.forgejo.settings.server.HTTP_ADDR}";
                extraConfig = # nginx
                  ''
                    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
                    add_header Content-Security-Policy "${
                      mkCSP {
                        default-src = "none";
                        connect-src = "self";
                        style-src = [
                          "self"
                          "unsafe-inline"
                        ];
                        script-src = [
                          "self"
                          "unsafe-inline"
                        ];
                        img-src = [
                          "self"
                          "data:"
                          "blob:"
                        ];
                      }
                    }" always;
                    add_header X-Content-Type-Options nosniff always;
                    add_header Referrer-Policy no-referrer always;
                    add_header Permissions-Policy "${
                      mkPP {
                        camera = "()";
                        microphone = "()";
                        geolocation = "()";
                        usb = "()";
                        bluetooth = "()";
                        payment = "()";
                        accelerometer = "()";
                        gyroscope = "()";
                        magnetometer = "()";
                        midi = "()";
                        serial = "()";
                        hid = "()";
                      }
                    }" always;
                    add_header Cross-Origin-Embedder-Policy require-corp always;
                    add_header Cross-Origin-Opener-Policy same-origin always;
                    add_header Cross-Origin-Resource-Policy same-origin always;
                  '';
              };
            };

            # NOTE: When starting forgejo for the first time run these commands:
            # sudo -u forgejo \
            #    <forgejo binary of systemd service> \
            #    forgejo-cli actions generate-secret \
            #    > ./runner-secret.txt
            # sudo -u forgejo \
            #    <forgejo binary of systemd service> \
            #    --config <forgejo statedir>/custom/conf/app.ini \
            #    forgejo-cli actions register \
            #    --name <instance name> \
            #    --secret-file ./runner-secret.txt
            # rm ./runner-secret.txt
            forgejo-runner.instances.runner = {
              enable = true;
              secrets.server.connections.default.token_url =
                config.sops.secrets."forgejo/runners/runner/default-connection".path;
              settings = {
                # FIX: Weird DNS issue when resolving docker hub
                container.network = config.virtualisation.podman.defaultNetwork.settings.name;
                # WARNING: Native host execution can brick host if action is malicious
                runner.labels = [
                  "debian-latest:docker://debian:latest"
                  "ubuntu-latest:docker://ubuntu:latest"
                  "arch-latest:docker://archlinux:latest"
                  "alpine-latest:docker://alpine:latest"
                ];
                server.connections.default = {
                  url = config.services.forgejo.settings.server.ROOT_URL;
                  uuid = "37666463-3966-6263-6365-633633343534";
                };
              };
            };
          };
        })

        {
          # NOTE: When starting forgejo for the first time run this command:
          # sudo -u forgejo \
          #   <forgejo binary of systemd service> \
          #   --config <forgejo statedir>/custom/conf/app.ini \
          #   admin auth add-oauth \
          #   --provider=openidConnect \
          #   --name=kanidm \
          #   --key=forgejo \
          #   --secret=<forgejo secret from kanidm> \
          #   --auto-discover-url=https://idm.srvd.space/oauth2/openid/forgejo/.well-known/openid-configuration \
          #   --scopes="openid email profile"
          #
          # NOTE: To Check that it worked here is the sanity check command:
          # sudo -u forgejo <forgejo binary of systemd service> admin auth list --config <forgejo statedir>/custom/conf/app.ini
          services.forgejo = {
            enable = true;
            package = pkgs.forgejo; # Newest version ;)
            lfs.enable = true;
            dump.enable = true;
            settings = {
              server = {
                HTTP_PORT = 36031;
                PROTOCOL = "http+unix";
                DOMAIN = "git.${config.networking.domain}";
                ROOT_URL = "https://${config.services.forgejo.settings.server.DOMAIN}";

                START_SSH_SERVER = true; # Needed because isn't started by default.
                SSH_PORT = 2222; # High port so that forgejo user can bind to it ;)
              };
              repository.DISABLE_HTTP_GIT = true;
              oauth2_client.ENABLE_AUTO_REGISTRATION = true;
              session.COOKIE_SECURE = true;
              service = {
                ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
                ENABLE_INTERNAL_SIGNIN = false;
                ENABLE_CAPTCHA = true;
              };
            };
          };
        }
      ];
  };
}
