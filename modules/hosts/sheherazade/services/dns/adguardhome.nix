toplevel@{ moduleWithSystem, ... }:
{
  den.aspects.sheherazade.nixos = moduleWithSystem (
    { system, ... }:
    { config, lib, ... }:
    let
      inherit (toplevel.config.flake.topology.${system}.config) networks;
      dnsPort = 53;
    in
    {
      services.caddy.virtualHosts."adguardhome.${config.networking.domain}".extraConfig = # caddy
        ''
          handle /oauth2/* {
              reverse_proxy ${config.services.oauth2-proxy.httpAddress} {
                  header_up X-Real-IP {remote_host}
                  header_up X-Forwarded-Uri {uri}
              }
          }

          handle {
              forward_auth ${config.services.oauth2-proxy.httpAddress} {
                  uri /oauth2/auth?allowed_groups=access_adguardhome

                  header_up X-Real-IP {remote_host}

                  copy_headers X-Auth-Request-User X-Auth-Request-Email

                  @error status 401
                  handle_response @error {
                      redir * /oauth2/sign_in?rd={scheme}://{host}{uri}
                  }
              }
              reverse_proxy http://${config.services.adguardhome.host}:${toString config.services.adguardhome.port}
          }
        '';

      networking.firewall = {
        allowedTCPPorts = [ dnsPort ];
        allowedUDPPorts = [ dnsPort ];
      };
      services.adguardhome = {
        enable = true;
        host = "[::1]";
        port = 3353;
        mutableSettings = false;
        settings = {
          auth_attempts = 3;
          block_auth_min = 5;
          dns = {
            port = dnsPort;
            bind_hosts = [
              "0.0.0.0"
              "::"
            ];
            allowed_clients = [
              "127.0.0.0/8"
              "::1/128"
            ]
            ++ (with networks.home; [
              cidrv4
              cidrv6
            ]);
            anonymize_client_ip = true;
            refuse_any = true;
            upstream_dns = [ "[::1]:${toString config.services.unbound.settings.server.port}" ];
            bootstrap_dns = [
              # Quad9
              "9.9.9.9"
              "149.112.112.112"
              "2620:fe::fe"
              "2620:fe::9"

              # Cloudflare
              "1.1.1.1"
              "1.0.0.1"
              "2606:4700:4700::1111"
              "2606:4700:4700::1001"
            ];
            bootstrap_prefer_ipv6 = true;
            serve_http3 = true;
            use_http3_upstreams = true;
            serve_plain_dns = true;
            hostsfile_enabled = true;
            # Unbound and systemd-resolved already cache the stuff.
            # This made a lot of issues in regards to CNAMEs and stuff.
            cache_enabled = false;
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
                  url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.plus.txt";
                  name = "Hagezi Multi Pro++";
                }
                {
                  url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.txt";
                  name = "Hagezi Threat Intelligence Feeds";
                }
                {
                  url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/dyndns.txt";
                  name = "Hagezi DynDNS";
                }
                {
                  url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adguard/dns-rebind-protection.txt";
                  name = "Hagezi DNS Rebind Protection";
                }
                {
                  url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/gambling.txt";
                  name = "Hagezi Gambling";
                }
                {
                  url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/nsfw.txt";
                  name = "Hagezi NSFW";
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
            "leagueoflegends"
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
            "netflix"
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
            "roblox"
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
            "valorant"
            "viber"
            "vimeo"
            "vivo_play"
            "vk"
            "voot"
            "wargaming"
            "wechat"
            "weibo"
            "wizz"
            "xiaohongshu"
            "yy"
            "zhihu"
          ];
        };
      };
    }
  );
}
