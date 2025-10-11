{ inputs, ... }:
{
  flake.modules.nixos.hosts-mahdi =
    { config, pkgs, ... }:
    let
      reverseProxyPort = 443;
      invisible = import (inputs.nix-invisible + /hosts/mahdi.nix);

      inherit (config.networking) domain;
    in
    {
      sops.secrets.ipv64_api_token = { };

      networking.firewall.allowedTCPPorts = [ reverseProxyPort ];

      security.acme = {
        acceptTerms = true;
        defaults = {
          inherit (invisible) email;
          dnsProvider = "ipv64";
          credentialFiles.IPV64_API_KEY_FILE = config.sops.secrets.ipv64_api_token.path;
        };
        # TODO: Remove Wildcard!
        certs.${domain}.extraDomainNames = [ "*.${domain}" ];
      };

      # Allow Nginx to read acme certificates
      users.users.nginx.extraGroups = [ "acme" ];

      # TODO: Enable DNS CAA
      # TODO: Enable SNI
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
      };
    };
}
