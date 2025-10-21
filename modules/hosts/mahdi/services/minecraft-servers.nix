{
  moduleWithSystem,
  inputs,
  customLib,
  ...
}:
{
  flake.modules.nixos.hosts-mahdi = moduleWithSystem (
    { inputs', ... }:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      velocityPort = 25565;
      mcPkgs = inputs'.nix-minecraft.legacyPackages;

      inherit (customLib.minecraft) collectMods;

      commonMods = {
        ALTERNATE_CURRENT = {
          url = "https://cdn.modrinth.com/data/r0v8vy1s/versions/eTNKfjl1/alternate-current-mc1.21.5-1.9.0.jar";
          sha512 = "3e4088170917846b30275825420b553e3fc3befb52bb259848853b93343bae3b39cd592902c0c79f05b17381d80170784990d9c4e110ff3b6c552e5508b40d67";
        };
        BETTER_FABRIC_CONSOLE = {
          url = "https://cdn.modrinth.com/data/Y8o1j1Sf/versions/DMBZUPjK/better-fabric-console-mc1.21.8-1.2.5.jar";
          sha512 = "d0de1aec66add0158e5a97424a21fc4bd0d26c54457d1bf15cd19e60939ed5d8b4dc4120a6aeec00925723b7dc431a9b84f60ad96d56a9e50620ef34b091cae6";
        };
        C2ME = {
          url = "https://cdn.modrinth.com/data/VSNURh3q/versions/7lwPGYpL/c2me-fabric-mc1.21.8-0.3.5%2Balpha.0.8.jar";
          sha512 = "d02ce60e3816326657e40a4cff8e1fdaea1911d8b429e82b23cde997f61c78ed0f68f32f7f57a58069cda624b688cabb863cba17a3d251eed32d6b17dabf70fc";
        };
        DEBUGIFY = {
          url = "https://cdn.modrinth.com/data/QwxR6Gcd/versions/WLSwJeXa/debugify-1.21.8%2B1.0.jar";
          sha512 = "5cbb7551e83abcc712a2d4b544d7f19cc1855eaede2350588b3f909966ae9248a7cdfd0c4d3cf53b796477f4327d735dadf83eddf40403a338d96ea9b9d727ca";
        };
        FABRIC_API = {
          url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/CF23l2iP/fabric-api-0.133.4%2B1.21.8.jar";
          sha512 = "e3cc9f8f60d655c916b2d31ca2a77fc15187e443e3bb8a5977dcff7a704401e8a39d633e12a649207a5923e540b6474e90f08c95655d07ae1c790d5c8aff41a5";
        };
        FABRIC_PROXY_LITE = {
          url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/KqB3UA0q/FabricProxy-Lite-2.10.1.jar";
          sha512 = "9c0c1d44ba27ed3483bb607f95441bea9fb1c65be26aa5dc0af743167fb7933623ba6129344738b084056aef7cb5a7db0db477348d07672d5c67a2e1204e9c94";
        };
        FERRITE_CORE = {
          url = "https://cdn.modrinth.com/data/uXXizFIs/versions/CtMpt7Jr/ferritecore-8.0.0-fabric.jar";
          sha512 = "131b82d1d366f0966435bfcb38c362d604d68ecf30c106d31a6261bfc868ca3a82425bb3faebaa2e5ea17d8eed5c92843810eb2df4790f2f8b1e6c1bdc9b7745";
        };
        KRYPTON = {
          url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/neW85eWt/krypton-0.2.9.jar";
          sha512 = "2e2304b1b17ecf95783aee92e26e54c9bfad325c7dfcd14deebf9891266eb2933db00ff77885caa083faa96f09c551eb56f93cf73b357789cb31edad4939ffeb";
        };
        LITHIUM = {
          url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/qxIL7Kb8/lithium-fabric-0.18.1%2Bmc1.21.8.jar";
          sha512 = "ef3e0820c7c831c352cbd5afa4a1f4ff73db0fa3c4e4428ba35ad2faeb8e7bce8ae4805a04934be82099012444a70c0a2cf2049f2af95fe688ca84d94d1c4672";
        };
        TAB_TPS = {
          url = "https://cdn.modrinth.com/data/cUhi3iB2/versions/w0oIAEFo/tabtps-fabric-mc1.21.8-1.3.28.jar";
          sha512 = "b29e19114efdadeadf5fedbf5b743aa35f36ab6fa8c32a1cbaa6591106677a3163801ba8010142899822298fefebb9621aa5db54db49ecc58719b7ef5dcbde85";
        };
      };

      # NOTE: If this gets annoying. Just leak the names & IDs. I don't care at this point.
      ops."ops.json".value = [
        {
          name = "@player1_name@";
          uuid = "@player1_id@";
          level = 4;
          bypassesPlayerLimit = true;
        }
        {
          name = "@player2_name@";
          uuid = "@player2_id@";
          level = 3;
          bypassesPlayerLimit = true;
        }
      ];

      allowedPlayers."whitelist.json".value = [
        {
          name = "@player1_name@";
          uuid = "@player1_id@";
        }
        {
          name = "@player2_name@";
          uuid = "@player2_id@";
        }
        {
          name = "@player3_name@";
          uuid = "@player3_id@";
        }
      ];
    in
    {
      imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

      sops.secrets."minecraft-server.env" = { };

      services.minecraft-servers = {
        enable = true;
        eula = true;
        environmentFile = config.sops.secrets."minecraft-server.env".path;
        servers = {
          Proxy = {
            enable = true;
            openFirewall = true;
            package = mcPkgs.velocity-server;
            stopCommand = "end";
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
                    inherit (config.services.minecraft-servers.servers) Creative Survival;
                  in
                  {
                    survival = "127.0.0.1:${toString Survival.serverProperties.server-port}";
                    creative = "127.0.0.1:${toString Creative.serverProperties.server-port}";
                    try = [
                      "creative"
                      "survival"
                    ];
                  };
              in
              {
                config-version = "2.7";

                bind = "0.0.0.0:${toString velocityPort}";
                motd = "<#09add3>A Velocity Server";

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
                  |> lib.mapAttrs' (n: _: lib.nameValuePair "${n}.${config.networking.domain}" [ n ]);

                advanced = {
                  compression-threshold = 256;
                  compression-level = -1;
                  login-ratelimit = 3000;
                  connection-timeout = 5000;
                  read-timeout = 30000;
                  haproxy-protocol = false;
                  tcp-fast-open = true; # Linux only
                  bungee-plugin-message-channel = true;
                  show-ping-requests = true;
                  failover-on-unexpected-server-disconnect = true;
                  announce-proxy-commands = true;
                  log-command-executions = true;
                  log-player-connections = true;
                  accepts-transfers = false;
                  enable-reuse-port = true; # Linux & macOS only
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
            openFirewall = false;
            package = mcPkgs.minecraftServers.fabric-1_21_8;
            jvmOpts = [
              "-Xms16G"
              "-Xmx16G"
            ];
            serverProperties = {
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
            files =
              ops
              // allowedPlayers
              // {
                "config/FabricProxy-Lite.toml".value = {
                  hackOnlineMode = true;
                  hackEarlySend = false;
                  hackMessageChain = false;
                  disconnectMessage = "You have to Connect via the Velocity Proxy Server";
                  secret = "@velocity_forward_secret@";
                };
              };
            symlinks.mods = collectMods {
              inherit pkgs;
              mods = commonMods;
            };
          };
          Creative = {
            enable = true;
            openFirewall = false;
            package = mcPkgs.minecraftServers.fabric-1_21_8;
            jvmOpts = [
              "-Xms16G"
              "-Xmx16G"
            ];
            serverProperties = {
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
            files =
              ops
              // allowedPlayers
              // {
                "config/FabricProxy-Lite.toml".value = {
                  hackOnlineMode = true;
                  hackEarlySend = false;
                  hackMessageChain = false;
                  disconnectMessage = "You have to Connect via the Velocity Proxy Server";
                  secret = "@velocity_forward_secret@";
                };
              };
            symlinks.mods = collectMods {
              inherit pkgs;
              mods = commonMods;
            };
          };
        };
      };
    }
  );
}
