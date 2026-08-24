{ den, ... }: {
  den.aspects.mahdi = {
    includes = [ den.aspects.virtualisation._.podman ];

    nixos =
      let
        companion = rec {
          # SAFETY: This is only useful if someone has direct access to the companion.
          key = "Ailai5oong1Eiyoi";
          port = "8282";
          ip = "fd00:d:a5::2";
          addr = "[${ip}]:${port}";
        };
      in
      { config, lib, ... }:
      lib.mkMerge [
        (lib.mkIf config.services.invidious.enable {
          services.nginx.virtualHosts.${config.services.invidious.domain} = {
            acmeRoot = null;
            forceSSL = lib.mkForce false;
            onlySSL = true;
            kTLS = true;
          };

          virtualisation.oci-containers.containers.invidious-companion = {
            image = "quay.io/invidious/invidious-companion:latest";
            pull = "newer";
            extraOptions = [ "--ip6=${companion.ip}" ];
            volumes = [ "companioncache:/var/tmp/youtubei.js:rw" ];
            environment = {
              HOST = companion.ip;
              PORT = companion.port;
              SERVER_SECRET_KEY = companion.key;
            };
          };
        })
        {
          services.invidious = {
            enable = true;
            port = 3031;
            domain = "yt.${config.networking.domain}";
            nginx.enable = true;
            serviceScale = 6;
            settings = {
              invidious_companion = [ { private_url = "http://${companion.addr}/companion"; } ];
              invidious_companion_key = companion.key;
              external_port = lib.mkForce config.services.nginx.defaultSSLListenPort;
              https_only = lib.mkForce true;
              popular_enabled = false;
              statistics_enabled = true;
              registration_enabled = true;
              login_enabled = true;
              captcha_enabled = true;
              use_pubsub_feeds = true;
              disable_abusable_api = true;
            };
          };
        }
      ];
  };
}
