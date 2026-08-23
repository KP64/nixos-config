{
  den.aspects.mahdi.nixos =
    { config, lib, ... }:
    let
      domain = "navidrome.${config.networking.domain}";
      inherit (config.lib.securityHeader) mkCSP;
    in
    lib.mkMerge [
      (lib.mkIf config.services.navidrome.enable {
        sops = {
          secrets."navidrome/encryption-key" = { };
          templates."navidrome.env" = {
            restartUnits = [ config.systemd.services.navidrome.name ];
            owner = config.users.users.navidrome.name;
            content = ''
              ND_PASSWORDENCRYPTIONKEY=${config.sops.placeholder."navidrome/encryption-key"}
            '';
          };
        };

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
                  add_header Cross-Origin-Embedder-Policy require-corp always;
                  add_header Cross-Origin-Opener-Policy same-origin always;
                  add_header Cross-Origin-Resource-Policy same-origin always;
                  add_header Content-Security-Policy "${
                    mkCSP {
                      default-src = "none";
                      img-src = [
                        "self"
                        "blob:"
                      ];
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
      })
      {
        services.navidrome = {
          enable = true;
          environmentFile = config.sops.templates."navidrome.env".path;
          settings = {
            Address = "[::1]";
            BaseUrl = "https://${domain}";
            SearchFullString = true;
            EnableSharing = true;
          };
        };
      }
    ];
}
