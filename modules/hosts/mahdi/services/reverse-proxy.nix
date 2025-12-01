{ inputs, ... }:
{
  flake.modules.nixos.hosts-mahdi =
    { config, pkgs, ... }:
    let
      invisible = import (inputs.nix-invisible + /hosts/mahdi.nix);
    in
    {
      sops.secrets.ipv64_api_token = { };

      security.acme = {
        acceptTerms = true;
        defaults = {
          inherit (invisible) email;
          dnsProvider = "ipv64";
          credentialFiles.IPV64_API_KEY_FILE = config.sops.secrets.ipv64_api_token.path;
        };
      };

      networking.firewall.allowedTCPPorts = [ 443 ];

      # NOTE: Amazing Websites:
      #  - https://securityheaders.com/
      #  - https://www.ssllabs.com/
      services.nginx = {
        enable = true;

        # QUIC connection migration -> More privileges but less interruptions
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
