{
  config,
  lib,
  invisible,
  ...
}:
let
  cfg = config.services.networking.traefik;
in
{
  options.services.networking.traefik.enable = lib.mkEnableOption "Traefik";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = [ 443 ];

      services.traefik =
        let
          certDir = "/var/lib/acme/${config.networking.domain}";
        in
        {
          enable = true;

          dynamicConfigOptions =
            let
              certs = {
                certFile = "${certDir}/cert.pem";
                keyFile = "${certDir}/key.pem";
              };
            in
            {
              tls = {
                stores.default.defaultCertificate = certs;
                certificates = [ (certs // { stores = "default"; }) ];
              };
            };

          staticConfigOptions = {
            global = {
              checkNewVersion = false;
              sendAnonymousUsage = false;
            };

            log = {
              level = "INFO";
              filePath = "${config.services.traefik.dataDir}/traefik.log";
              format = "json";
            };

            certificatesResolvers.letsencrypt.acme = {
              inherit (invisible) email;
              storage = "${config.services.traefik.dataDir}/cert.json";
              dnsChallenge = {
                provider = "ipv64";
                resolvers = [ "9.9.9.9:53" ];
              };
            };

            entryPoints.websecure = {
              address = ":443";
              asDefault = true;
              http.tls = {
                certResolver = "letsencrypt";
                domains = [
                  {
                    main = "${config.networking.domain}";
                    sans = [ "*.${config.networking.domain}" ];
                  }
                ];
              };
            };
          };
        };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories =
        lib.optional cfg.enable config.services.traefik.dataDir;
    })
  ];
}
