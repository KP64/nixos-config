{ customLib, ... }:
{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    let
      domain = "navidrome.${config.networking.domain}";
    in
    {
      services.nginx.virtualHosts.${domain} = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" =
          let
            inherit (config.services.navidrome.settings) Address Port;
          in
          {
            proxyPass = "http://${Address}:${toString Port}";
            extraConfig = # nginx
              ''
                add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
                add_header Content-Security-Policy "${
                  customLib.nginx.mkCSP {
                    default-src = "none";
                    img-src = "self";
                    media-src = "self";
                    style-src = [
                      "self"
                      "unsafe-inline"
                    ];
                    script-src = [
                      "self"
                      "unsafe-inline"
                    ];
                    connect-src = "self";
                  }
                }" always; 
              '';
          };
      };

      sops.secrets."navidrome.env" = { };

      services.navidrome = {
        enable = true;
        environmentFile = config.sops.secrets."navidrome.env".path;
        settings = {
          BaseUrl = "https://${domain}";
          SearchFullString = true;
        };
      };
    };
}
