{
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

        # TODO: Do all of this on a per virtualhost basis!
        #  - Make use of the more_headers module?
        appendHttpConfig = ''
          # Add HSTS header with preloading to HTTPS requests.
          # Adding this header to HTTP requests is discouraged
          map $scheme $hsts_header {
              https   "max-age=31536000; includeSubdomains; preload";
          }
          add_header Strict-Transport-Security $hsts_header always;

          # Minimize information leaked to other domains
          add_header Referrer-Policy 'strict-origin-when-cross-origin';

          # Disable embedding as a frame
          add_header X-Frame-Options DENY;

          # Prevent injection of code in other mime types (XSS Attacks)
          add_header X-Content-Type-Options nosniff;
        '';
      };
    };
}
