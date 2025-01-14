{ config, lib, ... }:
let
  cfg = config.services.security.acme;
in
{
  options.services.security.acme = {
    enable = lib.mkEnableOption "ACME";

    email = lib.mkOption {
      readOnly = true;
      type = lib.types.nonEmptyStr;
      example = "john@gmail.com";
      description = "The default Email for all Certificates";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      security.acme = {
        acceptTerms = true;
        defaults = {
          inherit (cfg) email;
          dnsProvider = "ipv64";
          credentialFiles = {
            IPV64_API_KEY_FILE = config.sops.secrets.acme_credentials.path;
          };
        };
        certs."${config.networking.domain}" = {
          group = "traefik";
          extraDomainNames = [ "*.${config.networking.domain}" ];
        };
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories = lib.optional cfg.enable "/var/lib/acme";
    })
  ];
}
