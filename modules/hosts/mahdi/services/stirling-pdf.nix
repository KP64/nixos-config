{
  flake.modules.nixos.hosts-mahdi =
    { config, lib, ... }:
    let
      inherit (config.lib.nginx) mkCSP mkPP;
    in
    lib.mkMerge [
      (lib.mkIf config.services.stirling-pdf.enable {
        sops.secrets."stirling-pdf.env" = { };

        services.nginx.virtualHosts."stirling-pdf.${config.networking.domain}" = {
          enableACME = true;
          acmeRoot = null;
          onlySSL = true;
          kTLS = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.stirling-pdf.environment.SERVER_PORT}";
            extraConfig = # nginx
              ''
                add_header Referrer-Policy no-referrer always;
                add_header Content-Security-Policy "${
                  mkCSP {
                    default-src = "none";
                    worker-src = [
                      "self"
                      "blob:"
                    ];
                    connect-src = [
                      "self"
                      "data:"
                      "blob:"
                    ];
                    style-src = [
                      "self"
                      "unsafe-inline"
                    ];
                    img-src = [
                      "self"
                      "data:"
                      "blob:"
                    ];
                    font-src = "self";
                    script-src = [
                      "self"
                      "unsafe-inline"
                      "unsafe-eval"
                    ];
                  }
                }" always;
                add_header Permissions-Policy "${
                  mkPP {
                    camera = "()";
                    microphone = "()";
                    geolocation = "()";
                    usb = "()";
                    bluetooth = "()";
                    payment = "()";
                    accelerometer = "()";
                    gyroscope = "()";
                    magnetometer = "()";
                    midi = "()";
                    serial = "()";
                    hid = "()";
                  }
                }" always;
              '';
          };
        };
      })
      {
        services.stirling-pdf = {
          enable = true;
          environmentFiles = [ config.sops.secrets."stirling-pdf.env".path ];
          environment =
            let
              SECURITY_OAUTH2_CLIENTID = "stirling-pdf";
              inherit (lib) boolToString;
            in
            {
              SERVER_PORT = 5982;
              SECURITY_ENABLELOGIN = boolToString true;
              SYSTEM_ENABLEANALYTICS = boolToString false;
              SYSTEM_FRONTENDURL = "https://stirling-pdf.${config.networking.domain}";
              SYSTEM_CORSALLOWEDORIGINS = "https://stirling-pdf.${config.networking.domain}";

              MAIL_ENABLED = boolToString false;

              UI_LOGOSTYLE = "modern";

              # NOTE: For first startup ever stay on "all".
              #       Promote the OAuth2 User to admin and then set
              #       Login method to oauth2. Otherwise every account
              #       will be regular users with no way to change that.
              #       AMAZING Design Stirling smh.
              SECURITY_LOGINMETHOD = "oauth2"; # "all"
              SECURITY_INITIALLOGIN_USERNAME = "admin";
              SECURITY_INITIALLOGIN_PASSWORD = "yourSecurePassword123";

              SECURITY_OAUTH2_ENABLED = boolToString true;
              SECURITY_OAUTH2_ISSUER = "${config.services.kanidm.server.settings.origin}/oauth2/openid/${SECURITY_OAUTH2_CLIENTID}";
              inherit SECURITY_OAUTH2_CLIENTID;
              SECURITY_OAUTH2_SCOPES = "openid, profile, email";
              SECURITY_OAUTH2_USEASUSERNAME = "email";
              SECURITY_OAUTH2_PROVIDER = "kanidm";
              SECURITY_OAUTH2_AUTOCREATEUSER = boolToString true;
              SECURITY_OAUTH2_BLOCKREGISTRATION = boolToString true;
            };
        };
      }
    ];
}
