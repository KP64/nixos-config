toplevel: {
  den.aspects.sheherazade.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      dnsPort = 53;
    in
    {
      networking.firewall = {
        allowedTCPPorts = [ dnsPort ];
        allowedUDPPorts = [ dnsPort ];
      };

      boot.kernel.sysctl = toplevel.config.lib.flake.util.toFlattenedByDots {
        net = {
          core = {
            rmem_max = 8388608;
            wmem_max = 8388608;
          };
          ipv4.tcp_max_syn_backlog = 256;
        };
      };

      services = {
        resolved.enable = false;
        unbound = {
          enable = true;
          # TODO: Remove
          localControlSocketPath = "/run/unbound/unbound.ctl";
          # NOTE: If keys rotate before nixpkgs can catch up by updating dns-root-data
          #       DNSSEC validation could fail. Enable this and remove `trust-anchor-file`
          #       from settings should that ever happen. The way it currently is,
          #       is technically more reproducible.
          enableRootTrustAnchor = false;
          settings = {
            server = {
              port = 5353;
              # NOTE: This is badly named. Apparently
              #       it should be the CPU core count
              num-threads = 2;
              prefer-ip6 = true;
              access-control = [
                "127.0.0.0/8 allow"
                "::1/128 allow"
                "192.168.0.0/16 allow"
                "fd00::/8 allow"
                "0.0.0.0/0 refuse"
                "::0/0 refuse"
              ];
              trust-anchor-file = "${pkgs.dns-root-data}/root.key";
              root-hints = "${pkgs.dns-root-data}/root.hints";

              harden-referral-path = true;
              qname-minimisation-strict = true;

              harden-large-queries = true;
              harden-unverified-glue = true;
              harden-algo-downgrade = true;
              harden-unknown-additional = true;
              use-caps-for-id = true;
              deny-any = true;

              answer-cookie = true;

              private-domain = [ "home.arpa" ];
              private-address = [
                "10.0.0.0/8"
                "172.16.0.0/12"
                "192.168.0.0/16"
                "169.254.0.0/16"
                "fd00::/8"
                "fe80::/10"

                "127.0.0.0/8"
                "::ffff:0:0/96"
              ];

              verbosity = 1;
              log-servfail = true;
              val-log-level = 1;

              # TODO: Remove
              extended-statistics = true;

              prefetch = true;
              prefetch-key = true;

              hide-identity = true;
              hide-version = true;
              hide-http-user-agent = true;

              rrset-cache-size = "100m";
              msg-cache-size = "50m";

              # Possible because of libevent
              outgoing-range = 8192;
              num-queries-per-thread = 4096;

              so-rcvbuf = "8m";
              so-sndbuf = "8m";
            };
          };
        };
        # TODO: Secure Web-Interface via oauth-proxy or similar!
        #        - Add proxy VHost
        #        - Close firewall port opening
        adguardhome = {
          enable = true;
          host = "[::]";
          port = 3353;
          openFirewall = true;
          mutableSettings = false;
          settings = {
            users = [
              {
                name = "kg";
                password = "$2y$10$8E0.opIZU4a297PV0e7K3.pF4hIfvatJ8YL/DHz2P.uRr8SDs.k7a";
              }
            ];
            auth_attempts = 3;
            block_auth_min = 5;
            dns = {
              bind_hosts = [
                "0.0.0.0"
                "::"
              ];
              port = dnsPort;
              anonymize_client_ip = false;
              refuse_any = true;
              upstream_dns = map (addr: "${addr}:${toString config.services.unbound.settings.server.port}") [
                "127.0.0.1"
                "[::1]"
              ];
              bootstrap_dns = [
                "9.9.9.9"
                "149.112.112.112"
                "2620:fe::fe"
                "2620:fe::9"
              ];
              allowed_clients = [
                "127.0.0.0/8"
                "::1/128"
                "192.168.0.0/16"
                "fd00::/8"
              ];
              bootstrap_prefer_ipv6 = true;
              serve_http3 = true;
              use_http3_upstreams = true;
              serve_plain_dns = true;
              hostsfile_enabled = true;
            };
            filters =
              lib.imap1
                (
                  i: filter:
                  filter
                  // {
                    enabled = true;
                    id = i;
                  }
                )
                [
                  {
                    url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
                    name = "AdGuard DNS filter";
                  }
                  {
                    url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt";
                    name = "Hagezi Multi Pro";
                  }
                  {
                    url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.txt";
                    name = "Hagezi Thread Intelligence Feeds";
                  }
                  {
                    url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adguard/dns-rebind-protection.txt";
                    name = "Hagezi DNS Rebind Protection";
                  }
                ];
            filtering.blocked_services.ids = [
              "4chan"
              "500px"
              "9gag"
              "aliexpress"
              "amazon_streaming"
              "amino"
              "apple_streaming"
              "betano"
              "betfair"
              "betway"
              "bigo_live"
              "bilibili"
              "blaze"
              "bluesky"
              "box"
              "canais_globo"
              "claro"
              "claude"
              "clubhouse"
              "coolapk"
              "copilot"
              "crunchyroll"
              "dailymotion"
              "deezer"
              "directvgo"
              "discord"
              "discoveryplus"
              "disneyplus"
              "douban"
              "dropbox"
              "espn"
              "fifa"
              "flickr"
              "gemini"
              "globoplay"
              "grok"
              "hbomax"
              "hulu"
              "icloud_private_relay"
              "iheartradio"
              "imgur"
              "instagram"
              "iqiyi"
              "kakaotalk"
              "kik"
              "kook"
              "lazada"
              "line"
              "linkedin"
              "lionsgateplus"
              "looke"
              "mail_ru"
              "manus"
              "mastodon"
              "max"
              "mercado_libre"
              "meta_ai"
              "microsoft_teams"
              "nebula"
              "ok"
              "olvid"
              "onlyfans"
              "paramountplus"
              "peacock_tv"
              "perplexity"
              "pinterest"
              "plenty_of_fish"
              "plex"
              "pluto_tv"
              "privacy"
              "qq"
              "rakuten_viki"
              "shein"
              "shopee"
              "skype"
              "slack"
              "snapchat"
              "soundcloud"
              "telegram"
              "temu"
              "tidal"
              "tiktok"
              "tinder"
              "tumblr"
              "twitch"
              "twitter"
              "viber"
              "vimeo"
              "vivo_play"
              "vk"
              "voot"
              "wechat"
              "weibo"
              "wizz"
              "xiaohongshu"
              "yy"
              "zhihu"
            ];
          };
        };
      };
    };
}
