{ inputs, ... }:
{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    let
      reverseProxyPort = 443;
      invisible = import "${inputs.nix-invisible}/hosts/mahdi.nix";

      inherit (config.networking) domain;
      certDir = config.security.acme.certs.${domain}.directory;
    in
    {
      sops.secrets.ipv64_api_token = { };

      networking.firewall.allowedTCPPorts = [ reverseProxyPort ];

      security.acme = {
        acceptTerms = true;
        defaults = { inherit (invisible) email; };
        certs.${domain} = {
          dnsProvider = "ipv64";
          credentialFiles.IPV64_API_KEY_FILE = config.sops.secrets.ipv64_api_token.path;
          group = "traefik";
          # TODO: Remove Wildcard!
          extraDomainNames = [ "*.${domain}" ];
        };
      };

      services.traefik = {
        enable = true;

        dynamicConfigOptions.tls =
          let
            certs = {
              certFile = "${certDir}/cert.pem";
              keyFile = "${certDir}/key.pem";
            };
          in
          {
            stores.default.defaultCertificate = certs;
            certificates = [ (certs // { stores = "default"; }) ];
          };

        staticConfigOptions = {
          global = {
            checkNewVersion = false;
            sendAnonymousUsage = false;
          };

          certificatesResolvers.letsencrypt.acme = {
            inherit (invisible) email;
            storage = "${config.services.traefik.dataDir}/acme.json";
            dnsChallenge = {
              provider = "ipv64";
              resolvers = map (r: "${r}:53") [
                "9.9.9.9"
                "1.1.1.1"
              ];
            };
          };

          entryPoints.websecure = {
            address = ":${toString reverseProxyPort}";
            asDefault = true;
            http.tls = {
              certResolver = "letsencrypt";
              domains = [
                {
                  main = "${domain}";
                  # TODO: Remove wildcard!
                  sans = [ "*.${domain}" ];
                }
              ];
            };
          };
        };
      };
    };
}
