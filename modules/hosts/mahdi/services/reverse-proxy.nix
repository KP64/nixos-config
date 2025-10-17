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

      services.nginx = {
        enable = true;

        # QUIC connection migration -> More privileges but less interruptions
        package = pkgs.nginxQuic;
        enableQuicBPF = true;

        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedUwsgiSettings = true;
        recommendedBrotliSettings = true;

        appendHttpConfig = ''
          # Add HSTS header with preloading to HTTPS requests.
          # Adding this header to HTTP requests is discouraged
          map $scheme $hsts_header {
              https   "max-age=31536000; includeSubdomains; preload";
          }
          add_header Strict-Transport-Security $hsts_header always;
        '';

        virtualHosts.${config.networking.domain} = {
          enableACME = true;
          acmeRoot = null;
          onlySSL = true;
          kTLS = true;
          locations."/" = {
            return = "200 '<html><body>Amazing. An empty Site! XD</body></html>'";
            extraConfig = ''
              default_type text/html;
            '';
          };
        };
      };
    };
}
