{
  lib,
  config,
  pkgs,
  username,
  stateVersion,
  ...
}:
{
  system = {
    inherit stateVersion;
    security = {
      uutils-coreutils.enable = true;
      polkit.enable = true;
      sudo-rs.enable = true;
    };
    services.ssh.enable = true;
  };

  home-manager.users.${username}.gtk.catppuccin.icon.enable = lib.mkForce false;

  cli = {
    defaults.enable = true;

    git = {
      enable = true;
      user = {
        name = "KP64";
        email = "karamalsadeh@hotmail.com";
      };
    };

    shells = {
      bash.enable = true;
      nushell.enable = true;
    };

    file-managers.yazi.enable = true;

    ricing.fetchers.enable = true;

    monitors = {
      btop.enable = true;
      bandwhich.enable = true;
    };
  };

  sdImage = {
    imageName = "kernel.img";
    compressImage = false;
  };

  # bcm2711 for rpi 3, 3+, 4, zero 2 w
  # bcm2712 for rpi 5
  # See the docs at:
  # https://www.raspberrypi.com/documentation/computers/linux_kernel.html#native-build-configuration
  raspberry-pi-nix.board = "bcm2711";

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    secrets = {
      hashed_password.neededForUsers = true;
      "wg/keys/client" = { };
      "wg/keys/server" = { };
      "wg/keys/preshared/lap" = { };
      "wg/keys/preshared/hon" = { };
    };
  };

  networking =
    let
      port = 58008;
    in
    {
      hostName = username;

      # TODO: Move with wireguard to own module
      nat = {
        enable = true;
        # TODO: Enable IPv6
        enableIPv6 = false;
        externalInterface = "end0";
        internalInterfaces = [ "wg0" ];
      };
      firewall = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [
          53
          port
        ];
      };

      # TODO: rs as server and client at the same time?
      wg-quick.interfaces =
        let
          inherit (config.sops) secrets;
          ipv4tables = "${pkgs.iptables}/bin/iptables";
        in
        {
          wg0 = {
            address = [ "172.31.0.1/32" ];
            listenPort = port;
            privateKeyFile = secrets."wg/keys/server".path;

            postUp = ''
              ${ipv4tables} -A FORWARD -i wg0 -j ACCEPT
              ${ipv4tables} -t nat -A POSTROUTING -s 172.31.0.1/32 -o end0 -j MASQUERADE
            '';

            postDown = ''
              ${ipv4tables} -D FORWARD -i wg0 -j ACCEPT
              ${ipv4tables} -t nat -D POSTROUTING -s 172.31.0.1/32 -o end0 -j MASQUERADE
            '';

            peers = [
              {
                publicKey = "lWc5hzembujk45Zxnhjcx/vE2b6sZLaagGdkMgpZs0o=";
                allowedIPs = [ "172.31.0.2/32" ];
                presharedKeyFile = secrets."wg/keys/preshared/lap".path;
              }
              {
                publicKey = "8Ms2xhDzF3xlAqe88FEKtGJWjZ7TPtvLX+yhM6ZL6m4=";
                allowedIPs = [ "172.31.0.3/32" ];
                presharedKeyFile = secrets."wg/keys/preshared/hon".path;
              }
            ];
          };
          # wg1 = {
          #   address = [ "10.2.0.2/32" ];
          #   dns = [ "10.2.0.1" ];
          #   privateKeyFile = secrets."wg/keys/client".path;
          #   peers = [
          #     {
          #       publicKey = "GqrhIyCiFfxq4hRI46+//Qtevp2D+gqzAIZrMAL//XM=";
          #       allowedIPs = [ "0.0.0.0/0" ];
          #       endpoint = "185.177.124.219:51820";
          #     }
          #   ];
          # };
        };
    };

  hardware = {
    bluetoothctl.enable = true;
    raspberry-pi.config.all = {
      options.force_turbo = {
        enable = true;
        value = true;
      };
      base-dt-params.krnbt = {
        enable = true;
        value = "on";
      };
    };
  };

  editors.helix.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  console.keyMap = "de";
  nixpkgs.config.allowUnfree = true;

  # TODO: Move with adguard
  environment.systemPackages = [ pkgs.adguardian ];
  services = {
    gaming.minecraft = {
      enable = false;
      ram = 2;
      serverProperties = {
        server-port = 42069;
        max-players = 2;
        difficulty = "hard";
        simulation-distance = 8;
        view-distance = 8;
      };
    };

    adguardhome = {
      enable = true;
      openFirewall = true;
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
        users = [
          {
            name = "ka64";
            password = "$2a$10$47XJ6KSFE4uXqACmYQQDaeDA4u6PVbCe8qD3xkcxel8TpwWBApawe";
          }
        ];
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
          upstream_dns = [ "https://dns10.quad9.net/dns-query" ];
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
        filters = [
          {
            enabled = true;
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
            name = "AdGuard DNS filter";
            id = 1;
          }
          {
            enabled = true;
            url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/pro.txt";
            name = "Hagezi Pro";
            id = 2;
          }
          {
            enabled = true;
            url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/tif.txt";
            name = "Hagezi TIFs";
            id = 3;
          }
          {
            enabled = true;
            url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/hoster.txt";
            name = "Hagezi Badware Hoster";
            id = 4;
          }
          {
            enabled = true;
            url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/spam-tlds.txt";
            name = "Hagezi Most Abused TLDs";
            id = 5;
          }
          {
            enabled = true;
            url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/gambling.txt";
            name = "Hagezi Gambling";
            id = 6;
          }
          {
            enabled = true;
            url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/native.winoffice.txt";
            name = "Hagezi Native Tracker Windows";
            id = 7;
          }
          {
            enabled = true;
            url = "https://nsfw.oisd.nl/";
            name = "oisd NSFW";
            id = 8;
          }
        ];
        whitelist_filters = [ ];
        user_rules = [ ];
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
            ids = [
              "4chan"
              "500px"
              "9gag"
              "aliexpress"
              "amazon"
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
              "cloudflare"
              "clubhouse"
              "coolapk"
              "crunchyroll"
              "dailymotion"
              "deezer"
              "directvgo"
              "discoveryplus"
              "disneyplus"
              "douban"
              "dropbox"
              "espn"
              "facebook"
              "fifa"
              "flickr"
              "globoplay"
              "gog"
              "hulu"
              "hbomax"
              "icloud_private_relay"
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
              "mastodon"
              "mail_ru"
              "looke"
              "mercado_libre"
              "nebula"
              "nintendo"
              "netflix"
              "ok"
              "olvid"
              "onlyfans"
              "pinterest"
              "paramountplus"
              "plenty_of_fish"
              "plex"
              "qq"
              "privacy"
              "pluto_tv"
              "rakuten_viki"
              "riot_games"
              "roblox"
              "shein"
              "shopee"
              "soundcloud"
              "skype"
              "snapchat"
              "telegram"
              "tiktok"
              "tidal"
              "temu"
              "tinder"
              "tumblr"
              "valorant"
              "twitter"
              "viber"
              "vimeo"
              "vk"
              "wechat"
              "wargaming"
              "voot"
              "weibo"
              "wizz"
              "xiaohongshu"
              "zhihu"
              "yy"
              "imgur"
            ];
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
          rewrites = [ ];
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

  users.users.${username} = {
    hashedPasswordFile = config.sops.secrets.hashed_password.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAprQ6/cB+MxEK5IorzJ1+/HoYqyc5ZItGG4HzYwTO3S karamalsadeh@hotmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICbBxsi/h7D+X+g3v2pXxwuQ6/TXLs2+Tb8R2Vl4ilLn kg@LapT"
    ];
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "docker"
      "libvirtd"
      "tss"
    ];
  };
}
