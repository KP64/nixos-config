toplevel: {
  flake.modules.nixos.hosts-mahdi =
    { config, lib, ... }:
    let
      domain = "opengist.${config.networking.domain}";
      inherit (config.lib.securityHeader) mkCSP mkPP;
    in
    {
      imports = [ toplevel.config.flake.modules.nixos.opengist ];

      config = lib.mkMerge [
        (lib.mkIf config.services.opengist.enable {
          sops.templates."opengist.env".content = ''
            OG_OIDC_SECRET=${config.sops.placeholder."kanidm/oauth2/opengist"}
          '';

          networking.firewall.allowedTCPPorts = [ config.services.opengist.environment.OG_SSH_PORT ];

          services.nginx.virtualHosts.${domain} = {
            enableACME = true;
            acmeRoot = null;
            onlySSL = true;
            kTLS = true;
            locations."/" = {
              proxyPass = "http://unix:${config.services.opengist.environment.OG_HTTP_HOST}";
              extraConfig = # nginx
                ''
                  add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
                  add_header Referrer-Policy no-referrer always;
                  add_header Content-Security-Policy "${
                    mkCSP {
                      default-src = "none";
                      connect-src = "self";
                      img-src = [
                        "self"
                        "https://www.gravatar.com"
                        "data:"
                      ];
                      font-src = "self";
                      style-src = [
                        "self"
                        "unsafe-inline"
                      ];
                      script-src = "self";
                      script-src-elem = [
                        "self"
                        "sha256-M2dIS+l3s6YjRwdsWi3BB1ccDTgR15K4A/1F38Q31cQ=" # English
                        "sha256-L64qqw2Tls7YoNhu1UStsiN8M1nXfyBcziLRX4peONI=" # Czech
                        "sha256-nRpRVsvoKePUoRX6uNHI3SelGSdFNHYp9auCLfiJndQ=" # German
                        "sha256-+dc4cDon0hKkRug3vTzVBs6WF2eRd66Q2gOGeTOdtCE=" # Spanish
                        "sha256-DQaZArrigGYDwcHlIgz+xRErnBuBvdMWawMnzMhxApA=" # Frensh
                        "sha256-OdS0b42U39nynrNsW5a0c3Xv1AaNu2vD8hWvqGJXg/w=" # Magyar
                        "sha256-dQaF857fedAI1q4ucNpxpHG30RJchlSMu4KzY68yHw4=" # Italian
                        "sha256-JnWTm4dd649663p5T/5eNJ5zmOSW+3yeQ+HgyrTSY/4=" # Japanese
                        "sha256-jXXRKP3ZsKeth4l+1bP8/K6h8gCe84X4cipr8zWHpAM=" # Polish
                        "sha256-cn5cgJUo2XfrwoypK5U0xLr3biVPXg3Gw4BL/FyVfaw=" # Portuguese
                        "sha256-AOmHIIIyi7XPFwi5MDW0y21IGLwksR1fPoJ6lktGcTo=" # Russian
                        "sha256-bO3NjU+ir+gYPp3Vk1kQW5VEaUtFSmxeTfwPp7Xuj0w=" # Turkish
                        "sha256-UmjofhSqx2um99QIT38RFK54P8A4NMcVgHyOghGortc=" # Ukrainian
                        "sha256-HiTBw4lkETmZj5/nQX0E8QWaYcDQpHOmJX7kMn5Pvhw=" # Chinese
                        "sha256-hxDao9xKGAsZnVhmZmzo2qzS7SjKkRum89Td3qYEcT4=" # Traditional Chinese
                      ];
                      script-src-attr = [
                        "unsafe-hashes"

                        # Account settings
                        "sha256-CglqgiRPhrm8WxeHqs5+97AdinxIwnDY2dJdMIg0w+8="
                        "sha256-QzFcEKxxzxoZPK6vHBO/Ot8kJWcRab88aD7fhIsaPl4="

                        # SSH settings
                        "sha256-uzdijtocYFMcmQBWONirlR4VlNgffpUN7pGBJP9BAM0="

                        # Create Access token
                        "sha256-e1v0A7s2JBk7M1cL+5aCdytHEy1ZC2Nzc8SSl0TT2AQ="

                        # Create new gist
                        "sha256-SlmWangwVIUdKAKuaGSvga8Cc4AXLkrjAPizQMjvU00="
                      ];
                    }
                  }";
                  add_header Permissions-Policy "${
                    mkPP {
                      camera = "()";
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
          services.opengist = {
            enable = true;
            environmentFile = config.sops.templates."opengist.env".path;
            environment =
              let
                OG_OIDC_CLIENT_KEY = "opengist";
              in
              {
                OG_EXTERNAL_URL = "https://${domain}";
                OG_SSH_PORT = 2223;
                OG_OIDC_PROVIDER_NAME = "Kanidm";
                inherit OG_OIDC_CLIENT_KEY;
                OG_OIDC_DISCOVERY_URL = "${config.services.kanidm.server.settings.origin}/oauth2/openid/${OG_OIDC_CLIENT_KEY}/.well-known/openid-configuration";
                OG_OIDC_GROUP_CLAIM_NAME = "groups";
                OG_OIDC_ADMIN_GROUP = "opengist.admins";
              };
          };
        }
      ];
    };
}
