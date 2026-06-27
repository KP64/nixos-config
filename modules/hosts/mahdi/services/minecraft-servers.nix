{ moduleWithSystem, inputs, ... }: {
  den.aspects.mahdi.nixos = moduleWithSystem (
    {
      config,
      inputs',
      pkgs,
      ...
    }:
    nixos@{ lib, ... }:
    let
      velocityPort = 25565;
      mcPkgs = inputs'.nix-minecraft.legacyPackages;

      mcLib = config.lib.minecraft;

      commonMods = {
        FABRIC_API = {
          url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/fm7UYECV/fabric-api-0.145.4%2B26.1.2.jar";
          sha512 = "ffd5ef62a745f76cd2e5481252cb7bc67006c809b4f436827d05ea22c01d19279e94a3b24df3d57e127af1cd08440b5de6a92a4ea8f39b2dcbbe1681275564c3";
        };
        FABRIC_PROXY_LITE = {
          url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/CsEpiziv/FabricProxy-Lite-2.12.0.jar";
          sha512 = "b479c3ed1fe83929cad40e5c925ae2702da879b88a0271a24266cd21ecc037953f347cbe61ac7b7334e087544ee2ce5bf1f041fc3e64f50474404ad564c146f7";
        };
        FERRITE_CORE = {
          url = "https://cdn.modrinth.com/data/uXXizFIs/versions/d5ddUdiB/ferritecore-9.0.0-fabric.jar";
          sha512 = "d81fa97e11784c19d42f89c2f433831d007603dd7193cee45fa177e4a6a9c52b384b198586e04a0f7f63cd996fed713322578bde9a8db57e1188854ae5cbe584";
        };
        LITHIUM = {
          url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/kHXOBNih/lithium-fabric-0.23.0%2Bmc26.1.1.jar";
          sha512 = "9d7e92ea2af7d024cfe09bfc7eacf236e551da024f4ddeb3a20d88b01bc3620ee1c5a3355299c9dbfcc76406fb0b8e121a989651e6a73c8c2632290f84db8448";
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
          owner = nixos.config.users.users.minecraft.name;
          restartUnits =
            nixos.config.systemd.services
            |> builtins.attrValues
            |> map (service: service.name)
            |> builtins.filter (lib.hasPrefix "minecraft-server-");
          content =
            let
              inherit (nixos.config) sops;
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
        environmentFile = nixos.config.sops.templates."minecraft-server.env".path;
        servers = {
          Proxy = {
            enable = true;
            openFirewall = true;
            package = mcPkgs.velocityServers.velocity-3_5_0-SNAPSHOT-build_598;
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
            symlinks."velocity.toml".value =
              let
                servers =
                  let
                    inherit (nixos.config.services.minecraft-servers.servers) Creative Survival;
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
                config-version = "2.7";

                bind = "[::]:${toString velocityPort}";
                motd = "<rainbow>Hello Minecraft Enthusiasts!</rainbow>";

                show-max-players = 500;
                online-mode = true;
                force-key-authentication = true;
                prevent-client-proxy-connections = true;

                player-info-forwarding-mode = "modern";
                forwarding-secret-file = "forwarding.secret";

                announce-forge = false;
                kick-existing-players = true;
                ping-passthrough = "mods";
                sample-players-in-ping = false;
                enable-player-address-logging = false;

                inherit servers;
                forced-hosts =
                  servers
                  |> lib.filterAttrs (n: _: n != "try")
                  |> lib.mapAttrs' (n: _: lib.nameValuePair "${n}.${nixos.config.networking.domain}" [ n ]);

                advanced = {
                  compression-threshold = 256;
                  compression-level = -1;
                  login-ratelimit = 3000;
                  connection-timeout = 5000;
                  read-timeout = 30000;
                  haproxy-protocol = false;
                  tcp-fast-open = pkgs.stdenv.isLinux;
                  bungee-plugin-message-channel = true;
                  show-ping-requests = true;
                  failover-on-unexpected-server-disconnect = true;
                  announce-proxy-commands = true;
                  log-command-executions = true;
                  log-player-connections = true;
                  accepts-transfers = false;
                  enable-reuse-port = with pkgs.stdenv; isLinux || isDarwin;
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

          Survival = {
            enable = true;
            package = mcPkgs.minecraftServers.fabric-26_1_1.override {
              jre_headless = pkgs.openjdk25_headless;
            };
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
            package = mcPkgs.minecraftServers.fabric-26_1_1.override {
              jre_headless = pkgs.openjdk25_headless;
            };
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
