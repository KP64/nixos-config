{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.networking.adguard;

  blockedServices = [
    "4chan"
    "500px"
    "9gag"
    "activision_blizzard"
    "aliexpress"
    "amazon"
    "amazon_streaming"
    "amino"
    "apple_streaming"
    "battle_net"
    "blizzard_entertainment"
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
    "cloudflare"
    "clubhouse"
    "coolapk"
    "crunchyroll"
    "dailymotion"
    "deezer"
    "directvgo"
    "discord"
    "discoveryplus"
    "disneyplus"
    "douban"
    "dropbox"
    "ebay"
    "electronic_arts"
    "epic_games"
    "espn"
    "facebook"
    "fifa"
    "flickr"
    "globoplay"
    "gog"
    "hulu"
    "hbomax"
    "icloud_private_relay"
    "imgur"
    "instagram"
    "iheartradio"
    "iqiyi"
    "kakaotalk"
    "kik"
    "leagueoflegends"
    "lazada"
    "kook"
    "line"
    "linkedin"
    "lionsgateplus"
    "looke"
    "mail_ru"
    "mastodon"
    "mercado_libre"
    "minecraft"
    "nebula"
    "nintendo"
    "nvidia"
    "netflix"
    "ok"
    "olvid"
    "onlyfans"
    "origin"
    "pinterest"
    "playstation"
    "paramountplus"
    "plenty_of_fish"
    "plex"
    "qq"
    "peacock_tv"
    "privacy"
    "pluto_tv"
    "rakuten_viki"
    "reddit"
    "riot_games"
    "roblox"
    "rockstar_games"
    "samsung_tv_plus"
    "shein"
    "shopee"
    "signal"
    "skype"
    "slack"
    "snapchat"
    "soundcloud"
    "spotify"
    "steam"
    "telegram"
    "temu"
    "tidal"
    "tiktok"
    "tinder"
    "tumblr"
    "twitch"
    "twitter"
    "ubisoft"
    "valorant"
    "viber"
    "vimeo"
    "vk"
    "voot"
    "wargaming"
    "wechat"
    "weibo"
    "whatsapp"
    "wizz"
    "xboxlive"
    "xiaohongshu"
    "youtube"
    "yy"
    "zhihu"
  ];
in
{
  # TODO: Enable Encrypted DNS
  options.services.networking.adguard = {
    enable = lib.mkEnableOption "AdguardHome";
    allowedServices = lib.mkOption {
      default = [ ];
      type = with lib.types; listOf nonEmptyStr;
      description = "The Services that shouldn't be blocked by adguard.";
      example = [
        "blizzard_activision"
        "youtube"
      ];
    };
    rewrites = lib.mkOption {
      default = [ ];
      description = ''
        The DNS rewrites.
        NOTE: If it doesn't work check that your router is not using some kind of rebind protection.
      '';
      example = [
        {
          domain = "pi.local";
          answer = "192.168.2.204";
        }
      ];
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            domain = lib.mkOption {
              readOnly = true;
              type = lib.types.nonEmptyStr;
              description = "The domain which points to the IP.";
            };
            answer = lib.mkOption {
              readOnly = true;
              type = lib.types.nonEmptyStr;
              description = "The IP to be pointed by the domain.";
            };
          };
        }
      );
    };
    users = lib.mkOption {
      default = [ ];
      description = "The users that are able to log in.";
      example = [
        {
          name = "admin";
          password = "12345";
        }
      ];
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              readOnly = true;
              type = lib.types.nonEmptyStr;
              example = "admin";
            };
            password = lib.mkOption {
              readOnly = true;
              type = lib.types.nonEmptyStr;
              example = "12345";
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.adguardian ];

    services = {
      traefik.dynamicConfigOptions.http = {
        routers.dns = {
          rule = "Host(`dns.${config.networking.domain}`)";
          service = "dns";
        };
        services.dns.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.adguardhome.port}"; }
        ];
      };

      adguardhome = {
        enable = true;
        port = 3520;
        mutableSettings = false;
        settings = {
          http = {
            pprof = {
              port = 6060;
              enabled = false;
            };
            session_ttl = "720h";
          };
          inherit (cfg) users;
          auth_attempts = 5;
          block_auth_min = 15;
          http_proxy = "";
          language = "";
          theme = "auto";
          dns = {
            bind_hosts = [ "0.0.0.0" ];
            port = 53;
            anonymize_client_ip = false;
            ratelimit = 20;
            ratelimit_subnet_len_ipv4 = 24;
            ratelimit_subnet_len_ipv6 = 56;
            ratelimit_whitelist = [ ];
            refuse_any = true;
            upstream_dns = [ "https://dns.quad9.net/dns-query" ];
            upstream_dns_file = "";
            bootstrap_dns = [
              "9.9.9.10"
              "149.112.112.10"
              "2620:fe::10"
              "2620:fe::fe:10"
            ];
            fallback_dns = [ ];
            upstream_mode = "load_balance";
            fastest_timeout = "1s";
            allowed_clients = [ ];
            disallowed_clients = [ ];
            blocked_hosts = [
              "version.bind"
              "id.server"
              "hostname.bind"
            ];
            trusted_proxies = [
              "127.0.0.0/8"
              "::1/128"
            ];
            cache_size = 4194304;
            cache_ttl_min = 0;
            cache_ttl_max = 0;
            cache_optimistic = false;
            bogus_nxdomain = [ ];
            aaaa_disabled = false;
            enable_dnssec = true;
            edns_client_subnet = {
              custom_ip = "";
              enabled = false;
              use_custom = false;
            };
            max_goroutines = 300;
            handle_ddr = true;
            ipset = [ ];
            ipset_file = "";
            bootstrap_prefer_ipv6 = true;
            upstream_timeout = "10s";
            private_networks = [ ];
            use_private_ptr_resolvers = true;
            local_ptr_upstreams = [ ];
            use_dns64 = false;
            dns64_prefixes = [ ];
            serve_http3 = true;
            use_http3_upstreams = true;
            # Never false unless one or more encrypted protocols enabled
            serve_plain_dns = true;
            hostsfile_enabled = true;
          };
          tls = {
            enabled = false;
            server_name = "";
            force_https = false;
            port_https = 443;
            port_dns_over_tls = 853;
            port_dns_over_quic = 853;
            port_dnscrypt = 0;
            dnscrypt_config_file = "";
            allow_unencrypted_doh = false;
            certificate_chain = "";
            private_key = "";
            certificate_path = "";
            private_key_path = "";
            strict_sni_check = false;
          };
          querylog = {
            dir_path = "";
            ignored = [ ];
            interval = "2160h";
            size_memory = 1000;
            enabled = true;
            file_enabled = true;
          };
          statistics = {
            dir_path = "";
            ignored = [ ];
            interval = "24h";
            enabled = true;
          };
          filters =
            lib.imap
              (
                idx: attr:
                attr
                // {
                  enabled = true;
                  id = idx;
                }
              )
              [
                {
                  url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
                  name = "AdGuard DNS filter";
                }
                {
                  url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/pro.txt";
                  name = "Hagezi Pro";
                }
                {
                  url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/tif.txt";
                  name = "Hagezi TIFs";
                }
                {
                  url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/hoster.txt";
                  name = "Hagezi Badware Hoster";
                }
                {
                  url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/spam-tlds.txt";
                  name = "Hagezi Most Abused TLDs";
                }
                {
                  url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/gambling.txt";
                  name = "Hagezi Gambling";
                }
                {
                  url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/native.winoffice.txt";
                  name = "Hagezi Native Tracker Windows";
                }
                {
                  url = "https://nsfw.oisd.nl/";
                  name = "oisd NSFW";
                }
              ];
          whitelist_filters = [ ];
          user_rules = map (toAllow: "@@||${toAllow}") [
            "flakehub.com^"
            "cloudfront.net^"
          ];
          dhcp = {
            enabled = false;
            interface_name = "";
            local_domain_name = "lan";
            dhcpv4 = {
              gateway_ip = "";
              subnet_mask = "";
              range_start = "";
              range_end = "";
              lease_duration = 86400;
              icmp_timeout_msec = 1000;
              options = [ ];
            };
            dhcpv6 = {
              range_start = "";
              lease_duration = 86400;
              ra_slaac_only = false;
              ra_allow_slaac = false;
            };
          };
          filtering = {
            blocking_ipv4 = "";
            blocking_ipv6 = "";
            blocked_services = {
              schedule.time_zone = "Local";
              ids =
                (
                  blockedServices
                  |> builtins.partition (toBlock: cfg.allowedServices |> builtins.any (toAllow: toAllow == toBlock))
                ).wrong;
            };
            protection_disabled_until = null;
            safe_search = {
              enabled = false;
              bing = true;
              duckduckgo = true;
              google = true;
              pixabay = true;
              yandex = true;
              youtube = true;
            };
            blocking_mode = "default";
            parental_block_host = "family-block.dns.adguard.com";
            safebrowsing_block_host = "standard-block.dns.adguard.com";
            inherit (cfg) rewrites;
            safebrowsing_cache_size = 1048576;
            safesearch_cache_size = 1048576;
            parental_cache_size = 1048576;
            cache_time = 30;
            filters_update_interval = 24;
            blocked_response_ttl = 10;
            filtering_enabled = true;
            parental_enabled = false;
            safebrowsing_enabled = false;
            protection_enabled = true;
          };
          clients = {
            runtime_sources = {
              whois = true;
              arp = true;
              rdns = true;
              dhcp = true;
              hosts = true;
            };
            persistent = [ ];
          };
          log = {
            enabled = true;
            file = "";
            max_backups = 0;
            max_size = 100;
            max_age = 3;
            compress = false;
            local_time = false;
            verbose = false;
          };
          os = {
            group = "";
            user = "";
            rlimit_nofile = 0;
          };
          schema_version = 28;
        };
      };
    };
  };
}
