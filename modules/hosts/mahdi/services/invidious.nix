{ den, ... }: {
  den.aspects.mahdi = {
    includes = [ den.aspects.virtualisation._.podman ];

    nixos =
      let
        # SAFETY: This is only useful if someone has direct access to the companion.
        companionKey = "Ailai5oong1Eiyoi";
        companionAddr = "127.0.0.1:8282";
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

          virtualisation.oci-containers.containers = {
            invidious-companion = {
              image = "quay.io/invidious/invidious-companion:latest";
              pull = "newer";
              ports = [ "${companionAddr}:8282" ];
              volumes = [ "companioncache:/var/tmp/youtubei.js:rw" ];
              environment.SERVER_SECRET_KEY = companionKey;
            };
          };
        })
        {
          services.invidious = {
            enable = true;
            port = 3031;
            domain = "yt.${config.networking.domain}";
            nginx.enable = true;
            settings = {
              invidious_companion = [ { private_url = "http://${companionAddr}/companion"; } ];
              invidious_companion_key = companionKey;
              external_port = lib.mkForce 443;
              https_only = lib.mkForce true;
              popular_enabled = false;
              statistics_enabled = true;
              registration_enabled = true;
              login_enabled = true;
              captcha_enabled = true;
              banner = "Happy Selfhosting";
              use_pubsub_feeds = true;
            };
          };
        }
      ];
  };
}
