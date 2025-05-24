{
  config,
  lib,
  invisible,
  ...
}:
let
  cfg = config.services.networking.traefik;
  inherit (config.networking) domain;
in
{
  options.services.networking.traefik.enable = lib.mkEnableOption "Traefik";

  config = lib.mkIf cfg.enable {
    networking.firewall =
      let
        port = 443;
      in
      {
        allowedTCPPorts = [ port ];
        allowedUDPPorts = [ port ];
      };

    services.traefik =
      let
        certDir = config.security.acme.certs.${domain}.directory;
        inherit (config.services.traefik) dataDir;
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
            filePath = "${dataDir}/traefik.log";
            format = "json";
          };

          certificatesResolvers.letsencrypt.acme = {
            inherit (invisible) email;
            storage = "${dataDir}/acme.json";
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
                  main = "${domain}";
                  sans = [ "*.${domain}" ];
                }
              ];
            };
          };
        };
      };
  };
}
