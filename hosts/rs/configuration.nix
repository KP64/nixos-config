{
  lib,
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

  networking.hostName = username;

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

  environment.systemPackages = [ pkgs.adguardian ];
  services = {
    openssh.enable = true;
    adguardhome = {
      enable = true;
      allowDHCP = false;
      openFirewall = true;
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
          upstream_dns = [
            "https://dns10.quad9.net/dns-query"
            # EDNS & DNSSEC Support
            "https://dns11.quad9.net/dns-query"
          ];
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
          use_dns64 = false; # TODO
          dns64_prefixes = [ ];
          serve_http3 = false; # TODO
          use_http3_upstreams = false; # TODO
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
          # TODO: More Filters
          {
            enabled = true;
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
            name = "AdGuard DNS filter";
            id = 1;
          }
          {
            enabled = true;
            url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/multi.txt";
            name = "Hagezi Normal Blocklist";
            id = 2;
          }
          {
            enabled = true;
            url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/tif.txt";
            name = "Hagezi TIF Blocklist";
            id = 3;
          }
          {
            enabled = true;
            url = "https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/spam-tlds.txt";
            name = "Hagezi Most Abused TLDs";
            id = 4;
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
            # TODO: Check restrictiveness and adjust
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
              "nvidia"
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
          rewrites = [ ]; # TODO: implement?
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

    minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      # TODO: Factor out minecraft servers to own customizable module with sensible defaults
      # TODO: Find a way to improve these abominations
      servers.cool-server1 = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21_1;
        serverProperties = {
          server-port = 42069;
          max-players = 2;
          difficulty = "hard";
          motd = "NixOS MC Server";
          simulation-distance = 8;
          view-distance = 8;
        };
        jvmOpts = builtins.concatStringsSep " " [
          "-Xms2G"
          "-Xmx2G"
          "-XX:+UseG1GC"
          "-XX:+ParallelRefProcEnabled"
          "-XX:MaxGCPauseMillis=200"
          "-XX:+UnlockExperimentalVMOptions"
          "-XX:+UnlockDiagnosticVMOptions"
          "-XX:+DisableExplicitGC"
          "-XX:+AlwaysPreTouch"
          "-XX:G1HeapWastePercent=5"
          "-XX:G1MixedGCCountTarget=4"
          "-XX:G1MixedGCLiveThresholdPercent=90"
          "-XX:G1RSetUpdatingPauseTimePercent=5"
          "-XX:SurvivorRatio=32"
          "-XX:+PerfDisableSharedMem"
          "-XX:MaxTenuringThreshold=1"
          "-XX:+UseStringDeduplication"
          "-XX:+UseFastUnorderedTimeStamps"
          "-XX:+UseAES"
          "-XX:+UseAESIntrinsics"
          "-XX:+UseFMA"
          "-XX:AllocatePrefetchStyle=1"
          "-XX:+UseLoopPredicate"
          "-XX:+RangeCheckElimination"
          "-XX:+EliminateLocks"
          "-XX:+DoEscapeAnalysis"
          "-XX:+UseCodeCacheFlushing"
          "-XX:+SegmentedCodeCache"
          "-XX:+UseFastJNIAccessors"
          "-XX:+OptimizeStringConcat"
          "-XX:+UseCompressedOops"
          "-XX:+UseThreadPriorities"
          "-XX:+OmitStackTraceInFastThrow"
          "-XX:+TrustFinalNonStaticFields"
          "-XX:ThreadPriorityPolicy=1"
          "-XX:+UseInlineCaches"
          "-XX:+RewriteBytecodes"
          "-XX:+RewriteFrequentPairs"
          "-XX:+UseNUMA"
          "-XX:-DontCompileHugeMethods"
          "-XX:+UseFPUForSpilling"
          "-XX:+UseVectorCmov"
          "-XX:+UseXMMForArrayCopy"
          "-Xlog:async"
          "-Djava.security.egd=file:/dev/urandom"
          "-XX:G1NewSizePercent=30"
          "-XX:G1MaxNewSizePercent=40"
          "-XX:G1HeapRegionSize=8M"
          "-XX:G1ReservePercent=20"
          "-XX:InitiatingHeapOccupancyPercent=15"
        ];
        symlinks = {
          # "ops.json" = pkgs.writeTextFile {
          #   name = "ops.json";
          #   text = ''
          #     [
          #         {
          #             "uuid": "",
          #             "name": "",
          #             "level": 4,
          #             "bypassesPlayerLimit": false
          #         }
          #     ]
          #   '';
          # };
          mods = pkgs.linkFarmFromDrvs "mods" (
            builtins.attrValues {
              c2m = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/VSNURh3q/versions/AHlC1pea/c2me-fabric-mc1.21.1-0.3.0%2Balpha.0.212.jar";
                sha512 = "a1977f3bb02a793677db0b0e20494af4bd648efd3b7e83d0c1ef3f14e7fdc0c4d3a9561b841fde97a123b87123275ce3c213bf414f91bc1393f26c95a70f0536";
              };
              fabric = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/qKPgBeHl/fabric-api-0.104.0%2B1.21.1.jar";
                sha512 = "0773f45d364b506b4e5b024aa8f1d498900fcf0a020d2025154e163e50a0eeee1b8296bf29c21df5ced42126ed46635e5ed094df25796ec552eb76399438e7e7";
              };
              ferrite_core = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/uXXizFIs/versions/wmIZ4wP4/ferritecore-7.0.0-fabric.jar";
                sha512 = "0f2f9b5aebd71ef3064fc94df964296ac6ee8ea12221098b9df037bdcaaca7bccd473c981795f4d57ff3d49da3ef81f13a42566880b9f11dc64645e9c8ad5d4f";
              };
              krypton = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/Acz3ttTp/krypton-0.2.8.jar";
                sha512 = "5f8cf96c79bfd4d893f1d70da582e62026bed36af49a7fa7b1e00fb6efb28d9ad6a1eec147020496b4fe38693d33fe6bfcd1eebbd93475612ee44290c2483784";
              };
              lithium = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/9x0igjLz/lithium-fabric-mc1.21.1-0.13.1.jar";
                sha512 = "4250a630d43492da35c4c197ae43082186938fdcb42bafcb6ccad925b79f583abdfdc17ce792c6c6686883f7f109219baecb4906a65d524026d4e288bfbaf146";
              };
              modern_fix = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/nmDcB62a/versions/T1ftCUJv/modernfix-fabric-5.19.3%2Bmc1.21.1.jar";
                sha512 = "36b4fa178e73b7eef5f42df619e67fe71307fafce8b1582acb11c36ad6792fafe88870d74e178898824ede405bd0873a8b00460f6507bdf87be9cfb6353edc7d";
              };
              niosium = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/KuNKN7d2/versions/4sGQgiu2/noisium-fabric-2.3.0%2Bmc1.21-1.21.1.jar";
                sha512 = "606ba78cf7f30d99e417c96aa042f600c1b626ed9c783919496d139de650013f1434fcf93545782e3889660322837ce6e85530d9e1a5cc20f9ad161357ede43e";
              };
              tabtps = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/cUhi3iB2/versions/XxA9k8Fb/tabtps-fabric-mc1.21.1-1.3.25.jar";
                sha512 = "81e4cb760be4b8cd25546f0d30a7a99d22aa05f71adef9a4a8e8ef0c95cf7f2ce79d004d12b4b8f061a73e675791a7723ae1d58e51caf70a0d64c6e60102eaa0";
              };
            }
          );
        };
      };
    };
  };

  users = {
    mutableUsers = false;
    users.${username} = {
      isNormalUser = true;
      description = username;
      hashedPassword = "$6$6pBc2nWaHAgS58.g$z0i6UxRA5AujL24HM3BRLTAm/.yiSo7nZs/rhz1jHfPqHe6dvMYmnLVPx1TO9Orsb9.JuvnQKTnw8Ae3lhBB5.";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAprQ6/cB+MxEK5IorzJ1+/HoYqyc5ZItGG4HzYwTO3S karamalsadeh@hotmail.com"
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
  };
}
