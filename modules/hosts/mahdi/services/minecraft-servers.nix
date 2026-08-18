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

      mcIcon = toplevel.config.lib.flake.util.getAsset {
        file = "minecraft.png";
        type = "icons";
        sha256 = "sha256-4/ScuncshJEfL6rFjBDC042ftXT2jXWC/5mqGZFpi/I=";
      };

      velocityPort = 25565;
      mcPkgs = inputs'.nix-minecraft.legacyPackages;
      mcLib = config.lib.minecraft;

      commonMods = {
        FABRIC_API = {
          url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/Kr4WG5mG/fabric-api-0.154.2%2B26.2.jar";
          sha512 = "7cedad862e8105a7de8db090c0707c25a14a9472654090861dcf490f834862c3212723e762f6f797a0e4683104f4b3a20d3692fb29d7b5c0af437613283d34db";
        };
        FABRIC_PROXY_LITE = {
          url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/CsEpiziv/FabricProxy-Lite-2.12.0.jar";
          sha512 = "b479c3ed1fe83929cad40e5c925ae2702da879b88a0271a24266cd21ecc037953f347cbe61ac7b7334e087544ee2ce5bf1f041fc3e64f50474404ad564c146f7";
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
            package = mcPkgs.velocityServers.velocity-3_5_0-SNAPSHOT-build_607;
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
                  servers =
                    let
                      inherit (config.services.minecraft-servers.servers) Creative Survival;
                    in
                    {
                      survival = "[${Survival.serverProperties.server-ip}]:${toString Survival.serverProperties.server-port}";
                      creative = "[${Creative.serverProperties.server-ip}]:${toString Creative.serverProperties.server-port}";
                      try = [
                        "creative"
                        "survival"
                      ];
                    };
                in
                {
                  config-version = "2.8";

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
                  ping-passthrough = "DISABLED";
                  sample-players-in-ping = false;
                  enable-player-address-logging = true;
                  packet-limiter = {
                    interval = 7;
                    packets-per-second = -1;
                    bytes-per-second = -1;
                    decompressed-bytes-per-second = 5242880;
                  };

                  inherit servers;
                  forced-hosts =
                    servers
                    |> lib.filterAttrs (n: _: n != "try")
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
                    haproxy-protocol = false;
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
            package = mcPkgs.minecraftServers.fabric-26_2.override { jre_headless = pkgs.openjdk25_headless; };
            jvmOpts = [
              "-Xms8G"
              "-Xmx8G"
              "-XX:+UseZGC"
              "-XX:+UseCompactObjectHeaders"
            ];
            serverProperties = {
              server-ip = "::1";
              server-port = 25566;
              difficulty = "hard";
              motd = "One Heck of a Server";
              simulation-distance = 16;
              view-distance = 32;
              gamemode = "survival";
              force-gamemode = true;
              online-mode = true;
              white-list = true;
              enforce-whitelist = true;
            };
            inherit operators whitelist;
            symlinks.mods = mcLib.collectMods commonMods;
          };
          Creative = {
            enable = true;
            package = mcPkgs.minecraftServers.fabric-26_2.override { jre_headless = pkgs.openjdk25_headless; };
            jvmOpts = [
              "-Xms8G"
              "-Xmx8G"
              "-XX:+UseZGC"
              "-XX:+UseCompactObjectHeaders"
            ];
            serverProperties = {
              server-ip = "::1";
              server-port = 25567;
              difficulty = "hard";
              motd = "One Heck of a Server";
              simulation-distance = 16;
              view-distance = 32;
              gamemode = "creative";
              force-gamemode = true;
              online-mode = true;
              white-list = true;
              enforce-whitelist = true;
            };
            inherit operators whitelist;
            symlinks.mods = mcLib.collectMods commonMods;
          };
        };
      };
    }
  );
}
