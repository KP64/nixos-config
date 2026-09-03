toplevel@{ moduleWithSystem, ... }:
{
  den.aspects.sheherazade.nixos = moduleWithSystem (
    { system, ... }:
    { config, lib, ... }:
    let
      inherit (config.lib.securityHeader) mkCSP mkPP;
    in
    {
      sops.secrets."oauth2-proxy/cookie-secret" = lib.mkIf config.services.oauth2-proxy.enable { };

      services.oauth2-proxy =
        let
          inherit (config.services) kanidm;
          clientID = "oauth2-proxy";
        in
        {
          enable = true;

          httpAddress = "http://[::1]:4180";

          extraConfig = {
            code-challenge-method = "S256";
            cookie-samesite = "strict";
            whitelist-domain = [ ".${config.networking.domain}" ];
          };

          provider = "oidc";
          oidcIssuerUrl = "${kanidm.server.settings.origin}/oauth2/openid/${clientID}";
          inherit clientID;
          clientSecretFile = config.sops.secrets."kanidm/oauth2/oauth2-proxy".path;
          redirectURL = "https://oauth2-proxy.${config.networking.domain}/oauth2/callback";
          email.domains = [ "*" ];

          cookie = {
            domain = ".${config.networking.domain}";
            secretFile = config.sops.secrets."oauth2-proxy/cookie-secret".path;
          };
          setXauthrequest = true;
          passAccessToken = true;
          reverseProxy = true;
          trustedProxyIP = [
            "127.0.0.0/8"
            "::1/128"
            toplevel.config.flake.topology.${system}.config.networks.home.cidrv6
          ];
        };

      services.caddy.virtualHosts."oauth2-proxy.${config.networking.domain}".extraConfig = # caddy
        ''
          header {
              Strict-Transport-Security "max-age=31536000; includeSubDomains"
              X-Frame-Options DENY
              X-Content-Type-Options nosniff
              Referrer-Policy no-referrer
              Cross-Origin-Embedder-Policy require-corp
              Cross-Origin-Opener-Policy same-origin
              Cross-Origin-Resource-Policy same-origin
              Content-Security-Policy "${
                mkCSP {
                  default-src = "none";
                  img-src = "self";
                  style-src-elem = [
                    "self"
                    "unsafe-inline"
                  ];
                  script-src-elem = "unsafe-inline";
                }
              }"
              Permissions-Policy "${
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
              }"
          }
          reverse_proxy ${config.services.oauth2-proxy.httpAddress}
        '';
    }
  );
}
