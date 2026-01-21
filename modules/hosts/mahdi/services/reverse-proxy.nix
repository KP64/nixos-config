{
  # TODO: From Reverse Proxy to Service should preferably be HTTPS too!
  # TODO: Add more/missing Security headers
  # TODO: Disable caching from OAauth endpoints!
  flake.modules.nixos.hosts-mahdi =
    { config, pkgs, ... }:
    {
      sops.secrets = {
        "rfc2136/nameserver" = { };
        "rfc2136/tsig_algorithm" = { };
        "rfc2136/tsig_key" = { };
        "rfc2136/tsig_secret" = { };
      };

      security.acme = {
        acceptTerms = true;
        defaults = {
          email = "lzkfaea17@mozmail.com";
          dnsProvider = "rfc2136";
          credentialFiles =
            let
              inherit (config.sops) secrets;
            in
            {
              RFC2136_NAMESERVER_FILE = secrets."rfc2136/nameserver".path;
              RFC2136_TSIG_ALGORITHM_FILE = secrets."rfc2136/tsig_algorithm".path;
              RFC2136_TSIG_KEY_FILE = secrets."rfc2136/tsig_key".path;
              RFC2136_TSIG_SECRET_FILE = secrets."rfc2136/tsig_secret".path;
            };
        };
      };

      networking.firewall.allowedTCPPorts = [ 443 ];

      # TODO: Enable ECH. DNS HTTPS Resource is prerequisite though.
      # NOTE: Amazing Websites:
      #  - https://securityheaders.com/
      #  - https://www.ssllabs.com/
      services.nginx = {
        enable = true;

        package = pkgs.nginxMainline;
        enableQuicBPF = true;

        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedUwsgiSettings = true;
        recommendedBrotliSettings = true;
      };
    };
}
