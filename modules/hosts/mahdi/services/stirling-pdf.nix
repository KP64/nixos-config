{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts."stirling-pdf.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.stirling-pdf.environment.SERVER_PORT}";
        };
      };

      sops.secrets."stirling-pdf.env" = { };

      # NOTE: Default credentials are:
      #       Username: admin
      #       Password: stirling
      services.stirling-pdf = {
        enable = true;
        environmentFiles = [ config.sops.secrets."stirling-pdf.env".path ];
        environment = {
          SERVER_PORT = 34509;
          SERVER_ADDRESS = "127.0.0.1"; # Default is 0.0.0.0

          SECURITY_ENABLELOGIN = "true";
          SECURITY_LOGINATTEMPTCOUNT = 5;
          SECURITY_LOGINMETHOD = "oauth2";
          SECURITY_OAUTH2_ENABLED = "true";
          SECURITY_OAUTH2_ISSUER = "https://${config.services.kanidm.serverSettings.domain}/oauth2/openid/stirling-pdf";
          SECURITY_OAUTH2_CLIENTID = "stirling-pdf";
          SECURITY_OAUTH2_BLOCKREGISTRATION = "false";
          SECURITY_OAUTH2_PROVIDER = "kanidm";

          SYSTEM_GOOGLEVISIBILITY = "false";
          SYSTEM_CUSTOMHTMLFILES = "false";
          SYSTEM_SHOWUPDATE = "false";
          SYSTEM_SHOWUPDATEONLYADMIN = "false";
          # Do not set to true. Security is at play.
          SYSTEM_ENABLEURLTOPDF = "false";
          SYSTEM_DISABLESANITIZE = "false";
        };
      };
    };
}
