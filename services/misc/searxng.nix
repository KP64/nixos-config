{ config, lib, ... }:
let
  cfg = config.services.misc.searxng;
in
{
  options.services.misc.searxng.enable = lib.mkEnableOption "SearXNG";

  config = lib.mkIf cfg.enable {
    sops.secrets."searx.env" = { };

    services = {
      traefik.dynamicConfigOptions.http = {
        routers.searxng = {
          rule = "Host(`searxng.${config.networking.domain}`)";
          service = "searxng";
        };
        services.searxng.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.searx.settings.server.port}"; }
        ];
      };

      searx = {
        enable = true;
        environmentFile = config.sops.secrets."searx.env".path;
        redisCreateLocally = true;

        limiterSettings = {
          real_ip = {
            x_for = 1;
            ipv4_prefix = 32;
            ipv6_prefix = 56;
          };

          botdetection.ip_limit = {
            filter_link_local = true;
            link_token = true;
          };
        };

        settings = {
          general = {
            debug = false;
            instance_name = "SearXNG Instance";
            donation_url = false;
            contact_url = false;
            privacypolicy_url = false;
            enable_metrics = false;
          };

          ui = {
            static_use_hash = true;
            center_alignment = true;
          };

          search = {
            default_lang = "all";
            ban_time_on_fail = 5;
            max_ban_tim_on_fail = 120;
          };

          server = {
            port = 8888;
            limiter = true;
            secret_key = "@SEARX_SECRET_KEY@";
          };

          enabled_plugins = [
            "Basic Calculator"
            "Hash plugin"
            "Tor check plugin"
            "Open Access DOI rewrite"
            "Hostnames plugin"
            "Unit converter plugin"
            "Tracker URL remover"
          ];

          engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
            # Wikimedia
            wikisource.disabled = false;
            wikiversity.disabled = false;

            # Images
            "duckduckgo images".disabled = false;

            findthatmeme.disabled = false;

            imgur.disabled = false;
            svgrepo.disabled = false;

            # Videos
            bilibili.disabled = false;
            invidious.disabled = false;

            # News
            "tagesschau".disabled = false;

            # IT
            "crates.io".disabled = false;
            "lib.rs".disabled = false;
            codeberg.disabled = false;
            "gitea.com".disabled = false;
            gitlab.disabled = false;
            sourcehut.disabled = false;
            cppreference.disabled = false;
            hackernews.disabled = false;

            # Files
            fdroid.disabled = false;

            # Social Media
            reddit.disabled = false;

            # Other

            ## Dictionaries
            duden.disabled = false;

            ## Movies
            imdb.disabled = false;
            rottentomatoes.disabled = false;
            tmdb.disabled = false;
            moviepilot.disabled = false;

            ## Shopping
            geizhals.disabled = false;

            ## Other
            wolframalpha.disabled = false;
            bpb.disabled = false;
            goodreads.disabled = false;
            yummly.disabled = false;
          };
        };
      };
    };
  };
}
