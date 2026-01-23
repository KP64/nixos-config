{ customLib, ... }:
{
  flake.modules.nixos.hosts-mahdi =
    { config, pkgs, ... }:
    {
      services.nginx.virtualHosts.${config.services.forgejo.settings.server.DOMAIN} = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://unix:${config.services.forgejo.settings.server.HTTP_ADDR}";
          extraConfig = # nginx
            ''
              add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
              add_header Content-Security-Policy "${
                customLib.nginx.mkCSP {
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
                  img-src = "self";
                }
              }" always;
              add_header X-Content-Type-Options nosniff always;
              add_header Referrer-Policy no-referrer always;
              add_header Permissions-Policy "${
                customLib.nginx.mkPP {
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
            '';
        };
      };

      networking.firewall.allowedTCPPorts = [ config.services.forgejo.settings.server.SSH_PORT ];

      # NOTE: Either podman or Docker needed for runners
      virtualisation.podman = {
        enable = true;
        autoPrune.enable = true;
      };
      services = {
        # TODO: Add Runners
        gitea-actions-runner = {
          package = pkgs.forgejo-runner;
          instances = { };
        };

        # NOTE: When running forgejo for the first time run this command:
        # sudo -u forgejo \
        #   <forgejo binary of systemd service> \
        #   --config <forgejo statedir>/custom/conf/app.ini \
        #   admin auth add-oauth \
        #   --provider=openidConnect \
        #   --name=kanidm \
        #   --key=forgejo \
        #   --secret=bogus \
        #   --auto-discover-url=https://idm.srvd.space/oauth2/openid/forgejo/.well-known/openid-configuration \
        #   --scopes="openid email profile"
        #
        # To Check that it worked here is the sanity check command:
        # sudo -u forgejo <forgejo binary of systemd service> admin auth list --config <forgejo statedir>/custom/conf/app.ini
        forgejo = {
          enable = true;
          package = pkgs.forgejo; # Newest version ;)
          lfs.enable = true;
          dump.enable = true;
          # database.passwordFile = "";
          # secrets = { };
          settings = {
            server = {
              HTTP_PORT = 36031;
              PROTOCOL = "http+unix";
              DOMAIN = "forgejo.${config.networking.domain}";
              ROOT_URL = "https://${config.services.forgejo.settings.server.DOMAIN}";

              START_SSH_SERVER = true; # Needed because isn't started by default.
              SSH_PORT = 2222; # High port so that forgejo user can bind to it ;)
            };
            repository.DISABLE_HTTP_GIT = true;
            security = {
              PASSWORD_COMPLEXITY = "lower,upper,digit,spec";
              PASSWORD_CHECK_PWN = true;
            };
            oauth2_client.ENABLE_AUTO_REGISTRATION = true;
            session.COOKIE_SECURE = true;
            service = {
              ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
              ENABLE_INTERNAL_SIGNIN = false;
              ENABLE_CAPTCHA = true;
            };
          };
        };
      };
    };
}
