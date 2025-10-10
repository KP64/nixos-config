{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts."stirling-pdf.${config.networking.domain}" = {
        useACMEHost = config.networking.domain;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.stirling-pdf.environment.SERVER_PORT}";
        };
      };

      # NOTE: Default credentials are:
      #       Username: admin
      #       Password: stirling
      services.stirling-pdf = {
        enable = true;
        environment = {
          SERVER_PORT = 34509;
          SERVER_ADDRESS = "127.0.0.1"; # Default is 0.0.0.0

          SECURITY_ENABLELOGIN = "true";
          SECURITY_LOGINATTEMPTCOUNT = 5;
          # TODO: Support OAUTH once ready
          SECURITY_LOGINMETHOD = "normal";
          SECURITY_OAUTH2_ENABLED = "false";

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
