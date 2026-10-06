toplevel@{ moduleWithSystem, inputs, ... }:
{
  den.aspects.mahdi.nixos = moduleWithSystem (
    { inputs', ... }:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      subdomain = "mc";

      jre_headless = pkgs.jdk25_headless;

      mcIcon = toplevel.config.lib.flake.util.getAsset {
        file = "minecraft.png";
        type = "icons";
        sha256 = "sha256-4/ScuncshJEfL6rFjBDC042ftXT2jXWC/5mqGZFpi/I=";
      };

      velocityPort = 25565;
      mcPkgs = inputs'.nix-minecraft.legacyPackages;
      mcLib = config.lib.minecraft;

      default = {
        package = mcPkgs.minecraftServers.fabric-26_3.override { inherit jre_headless; };
        jvmOpts = [
          "-Xms8G"
          "-Xmx8G"
          "-XX:+UseZGC"
          "-XX:+UseCompactObjectHeaders"
        ];
        serverProperties = {
          server-ip = "::1";
          snooper-enabled = false;
          force-gamemode = true;
          online-mode = true;
          white-list = true;
          enforce-whitelist = true;

          simulation-distance = 16;
          view-distance = 32;
        };
        mods = {
          FABRIC_API = {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/bNnaTiuM/fabric-api-0.161.0%2B26.3.jar";
            sha512 = "ed6b2586d6fde11fde8472f5a527c51e99b67026e46f94d4bfd85e7e28ce5ee299173ee16ad576ceb51f39f98d30a811086a6deb1a86a524859cc16e12da109d";
          };
          FABRIC_PROXY_LITE = {
            url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/CsEpiziv/FabricProxy-Lite-2.12.0.jar";
            sha512 = "b479c3ed1fe83929cad40e5c925ae2702da879b88a0271a24266cd21ecc037953f347cbe61ac7b7334e087544ee2ce5bf1f041fc3e64f50474404ad564c146f7";
          };
          FERRITE_CORE = {
            url = "https://cdn.modrinth.com/data/uXXizFIs/versions/d5ddUdiB/ferritecore-9.0.0-fabric.jar";
            sha512 = "d81fa97e11784c19d42f89c2f433831d007603dd7193cee45fa177e4a6a9c52b384b198586e04a0f7f63cd996fed713322578bde9a8db57e1188854ae5cbe584";
          };
          C2ME = {
            url = "https://cdn.modrinth.com/data/VSNURh3q/versions/FXjQDzq7/c2me-fabric-mc26.3-0.4.2-alpha.0.89.jar";
            sha512 = "b4fcf82bbe15bfa253e3ab6df4d6b64e800a2ccdb45d4ca2b8040da87f72033fed34f4f94016aac507596c78fddb18dba28c6642790181642cae46fae28b3a85";
          };
          CLUMPS = {
            url = "https://cdn.modrinth.com/data/Wnxd13zP/versions/J4I1wxJZ/Clumps-fabric-26.3-26.3.2.jar";
            sha512 = "8c166ae97e1999d0f213d0a181d6ef87b99648016c92c9aa1414d2c2e24364b12549569cd7e247a3d675df703ae6a8a88fc175d3f527818c710578408508c8ab";
          };
          KRYPTON = {
            url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/UugdIYJw/krypton-0.3.2.jar";
            sha512 = "d1d57ebd41395b75b01f130cd9503eb8d208212424a399ff9f367f50be8fbc1c6472442b33c686e777c3148f6a609520e8fb732c755157c358cb207fd4d1123a";
          };
          LITHIUM = {
            url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/xS0Q8LSi/lithium-fabric-0.26.2%2Bmc26.3.jar";
            sha512 = "4d7fee66132eedc71feab9390b92c95d7058edbdad0fecfac1d836a2950b97a7ca463afbede61c7ef361ce65e1f927ab9e89dde5bf2e0e0ce486afb5c5dbee40";
          };
        };
      };

      operators = {
        KGamer_64 = {
          uuid = "dae6014c-cd91-4038-830f-99c8c986e997";
          level = 4;
          bypassesPlayerLimit = true;
        };
        macoreix = {
          uuid = "65fe7054-52d1-4418-bca5-4177238180b2";
          level = 3;
          bypassesPlayerLimit = true;
        };
      };

      whitelist = (builtins.mapAttrs (_: v: v.uuid) operators) // {
        Schmalzheimer = "e3e97e3d-dab1-4b4b-9e9c-00eda78506eb";
      };
    in
    {
      imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

      sops = {
        secrets."minecraft/velocity-forwarding" = { };
        templates."minecraft-server.env" = {
          owner = config.users.users.minecraft.name;
          restartUnits =
            config.systemd.services
            |> builtins.attrValues
            |> map (service: service.name)
            |> builtins.filter (lib.hasPrefix "minecraft-server-");
          content =
            let
              inherit (config) sops;
            in
            ''
              VELOCITY_FORWARDING_SECRET=${sops.placeholder."minecraft/velocity-forwarding"}
              FABRIC_PROXY_SECRET=${sops.placeholder."minecraft/velocity-forwarding"}
            '';
        };
      };

      services.minecraft-servers = {
        enable = true;
        eula = true;
        environmentFile = config.sops.templates."minecraft-server.env".path;
        servers = {
          Proxy = {
            enable = true;
            openFirewall = true;
            package = mcPkgs.velocityServers.velocity-4_2_1-SNAPSHOT-build_36.override {
              inherit jre_headless;
            };
            # Recommended by https://docs.papermc.io/velocity/tuning/#tune-your-startup-flags
            jvmOpts = [
              "-Xms2G"
              "-Xmx2G"
              "-XX:+UseG1GC"
              "-XX:G1HeapRegionSize=4M"
              "-XX:+UnlockExperimentalVMOptions"
              "-XX:+ParallelRefProcEnabled"
              "-XX:+AlwaysPreTouch"
              "-XX:MaxInlineLevel=15"
            ];
            symlinks = {
              "server-icon.png" = mcIcon;
              "velocity.toml".value =
                let
                  backendServers =
                    config.services.minecraft-servers.servers
                    |> lib.filterAttrs (
                      _: v:
                      # NOTE: Checking the derivation itself isn't enough as overriding (e.g. jre_headless) would invalidate the check.
                      #       That's why checking the package name is easier and more robust.
                      !(v.package |> lib.getName |> lib.hasInfix "velocity")
                    )
                    |> builtins.mapAttrs (
                      _: v: "[${v.serverProperties.server-ip}]:${toString v.serverProperties.server-port}"
                    );
                in
                {
                  config-version = "2.9";

                  bind = "[${config.staticIPv6}]:${toString velocityPort}";
                  motd = "<rainbow>Hello Minecraft Enthusiasts!</rainbow>";

                  show-max-players = 500;
                  online-mode = true;
                  force-key-authentication = true;
                  prevent-client-proxy-connections = false;

                  player-info-forwarding-mode = "modern";
                  forwarding-secret-file = "forwarding.secret";

                  announce-forge = false;
                  kick-existing-players = true;
                  sample-players-in-ping = false;
                  enable-player-address-logging = true;
                  packet-limiter = {
                    interval = 7;
                    packets-per-second = -1;
                    bytes-per-second = -1;
                    decompressed-bytes-per-second = 5242880;
                  };
                  ping-passthrough = {
                    version = false;
                    players = false;
                    description = false;
                    favicon = false;
                    modinfo = false;
                  };

                  servers = backendServers // {
                    try = builtins.attrNames backendServers;
                  };

                  forced-hosts =
                    backendServers
                    |> lib.mapAttrs' (
                      n: _: {
                        name = "${n}.${subdomain}.${config.networking.domain}";
                        value = [ n ];
                      }
                    );
                  advanced = {
                    compression-threshold = 256;
                    compression-level = -1;
                    login-ratelimit = 3000;
                    connection-timeout = 5000;
                    read-timeout = 30000;
                    haproxy-protocol = true;
                    tcp-fast-open = pkgs.stdenvNoCC.hostPlatform.isLinux;
                    bungee-plugin-message-channel = true;
                    show-ping-requests = true;
                    failover-on-unexpected-server-disconnect = true;
                    announce-proxy-commands = true;
                    log-command-executions = true;
                    log-player-connections = true;
                    accepts-transfers = false;
                    enable-reuse-port = with pkgs.stdenvNoCC.hostPlatform; isLinux || isDarwin;
                    command-rate-limit = 50;
                    forward-commands-if-rate-limited = true;
                    kick-after-rate-limited-commands = 0;
                    tab-complete-rate-limit = 10;
                    kick-after-rate-limited-tab-completes = 0;
                  };

                  query = {
                    enabled = false;
                    port = velocityPort;
                    map = "Velocity";
                    show-plugins = false;
                  };
                };
            };
          };
          Survival = {
            enable = true;
            inherit (default) package jvmOpts;
            serverProperties = default.serverProperties // {
              server-port = 25566;
              difficulty = "hard";
              gamemode = "survival";
            };
            inherit operators whitelist;
            symlinks.mods = mcLib.collectMods default.mods;
          };
          Creative = {
            enable = true;
            inherit (default) package jvmOpts;
            serverProperties = default.serverProperties // {
              server-port = 25567;
              gamemode = "creative";
            };
            inherit operators whitelist;
            symlinks.mods = mcLib.collectMods default.mods;
          };
          Hardcore = {
            enable = true;
            inherit (default) package jvmOpts;
            serverProperties = default.serverProperties // {
              server-port = 25568;
              hardcore = true; # implies hard difficulty
            };
            inherit operators whitelist;
            symlinks.mods = mcLib.collectMods default.mods;
          };
        };
      };
    }
  );
}
