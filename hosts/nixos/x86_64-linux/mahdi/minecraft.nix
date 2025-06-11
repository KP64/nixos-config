{
  config,
  lib,
  pkgs,
  ...
}:
let
  velocityPort = 25565;
in
{
  # Nix-Minecraft only opens the TCP Port.
  # UDP is needed for Geyser & Floodgate.
  networking.firewall.allowedUDPPorts = [ velocityPort ];

  services.gaming.minecraft = {
    environmentFile = config.sops.secrets."minecraft.env".path;
    servers = rec {
      Proxy = {
        openFirewall = true;
        type = "velocity";
        ram = 8;
        jvmOpts = map (o: "-XX:${o}") [
          "+UseG1GC"
          "G1HeapRegionSize=4M"
          "+UnlockExperimentalVMOptions"
          "+ParallelRefProcEnabled"
          "+AlwaysPreTouch"
          "MaxInlineLevel=15"
        ];
        files = {
          "plugins/Geyser-Velocity/config.yml".value = {
            bedrock = {
              clone-remote-port = true;
              server-name = "Geyser Proxy";
              compression-level = 6;
              enable-proxy-protocol = false;
            };
            remote = {
              address = "auto";
              # handled by "auto" address
              # port = velocityPort;
              # auth-type = "floodgate";
              use-proxy-protocol = false;
              forward-hostname = true;
            };
            pending-authentication-timeout = 120;
            command-suggestions = true;
            passthrough-motd = true;
            passthrough-player-counts = true;
            legacy-ping-passthrough = false;
            ping-passthrough-interval = 3;
            forward-player-ping = false;
            max-players = 100;
            debug-mode = false;
            show-cooldown = "title";
            show-coordinates = true;
            disable-bedrock-scaffolding = false;
            emote-offhand-workaround = "disabled";
            cache-images = 0;
            allow-custom-skulls = true;
            max-visible-custom-skulls = 128;
            custom-skull-render-distance = 32;
            add-non-bedrock-items = true;
            above-bedrock-nether-building = false;
            force-resource-packs = true;
            xbox-achievements-enabled = false;
            log-player-ip-addresses = true;
            notify-on-new-bedrock-update = true;
            unusable-space-block = "minecraft:barrier";
            metrics = {
              enabled = true;
              uuid = "@server_id@";
            };
            scoreboard-packet-threshold = 20;
            enable-proxy-connections = false;
            mtu = 1400;
            use-direct-connection = true;
            disable-compression = true;
            config-version = 4;
          };

          "plugins/floodgate-velocity.jar" =
            let
              jarExtList =
                { }:
                {
                  type = with lib.types; listOf path;
                  generate = name: value: builtins.head value;
                };
            in
            {
              format = jarExtList { };
              value = [ ./floodgate-velocity.jar ];
            };
          plugins =
            {
              GEYSER_MC = {
                url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/8VztpHb8/Geyser-Velocity.jar";
                sha512 = "6f50bb0cce3c876eb52ba4a3b3bdb73ca2d82507cdbcc083896f43a13ff8f4d16c5e116baaee2c0c197799ef97360d5378381089d2f0be1b71418726cc90bf33";
              };
            }
            |> builtins.attrValues
            |> map pkgs.fetchurl
            |> pkgs.linkFarmFromDrvs "plugins";
        };
        symlinks."velocity.toml".value = rec {
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
          ping-passthrough = "DISABLED";
          sample-players-in-ping = true;
          enable-player-address-logging = true;

          servers = {
            warden = "127.0.0.1:${toString Warden.serverProperties.server-port}";
            liberator = "127.0.0.1:${toString Liberator.serverProperties.server-port}";
            try = [
              "warden"
              "liberator"
            ];
          };

          forced-hosts =
            servers
            |> builtins.attrNames
            |> builtins.filter (n: n != "try")
            |> map (n: lib.nameValuePair "${n}.${config.networking.domain}" [ n ])
            |> builtins.listToAttrs;

          advanced = {
            compression-threshold = 256;
            compression-level = -1;
            login-ratelimit = 3000;
            connection-timeout = 5000;
            read-timeout = 30000;
            haproxy-protocol = false;
            tcp-fast-open = true;
            bungee-plugin-message-channel = true;
            show-ping-requests = true;
            failover-on-unexpected-server-disconnect = true;
            announce-proxy-commands = true;
            log-command-executions = false;
            log-player-connections = true;
            accepts-transfers = false;
            enable-reuse-port = true;
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
      Liberator = {
        version = "1.21.5";
        type = "fabric";
        ram = 8;
        serverProperties = {
          server-port = 25567;
          motd = "Liberty";
          difficulty = "hard";
          simulation-distance = 16;
          view-distance = 32;
          gamemode = "creative";
          online-mode = false;
          force-gamemode = true;
        };
        files."config/FabricProxy-Lite.toml".value = {
          hackOnlineMode = true;
          hackEarlySend = false;
          hackMessageChain = true;
          disconnectMessage = "You have to Connect via the Velocity Proxy Server";
          secret = "@velocity_secret@";
        };
        mods.FABRIC_PROXY_LITE = {
          url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/AQhF7kvw/FabricProxy-Lite-2.9.0.jar";
          sha512 = "3044f36df7e83021210a7c318def18a95b5dbf5e3230bb72a3ddb42ebdda33f248c6d12efcee1240ff0c54600d68d147afa105d04ee37a90acb9409619c89848";
        };
      };
      Warden = {
        version = "1.21.5";
        type = "fabric";
        ram = 24;
        serverProperties = {
          server-port = 25566;
          max-players = 32;
          difficulty = "hard";
          motd = "One Heck of a Server";
          simulation-distance = 16;
          view-distance = 32;
          gamemode = "survival";
          online-mode = false; # Correct: Disabled because of Velocity
          white-list = true;
          enforce-whitelist = true;
          force-gamemode = true;
        };
        files = {
          "ops.json".value = [
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
          "whitelist.json".value = [
            {
              name = "@player1_name@";
              uuid = "@player1_id@";
            }
            {
              name = "@player2_name@";
              uuid = "@player2_id@";
            }
          ];
          "config/FabricProxy-Lite.toml".value = {
            hackOnlineMode = true;
            hackEarlySend = false;
            hackMessageChain = true;
            disconnectMessage = "You have to Connect via the Velocity Proxy Server";
            secret = "@velocity_secret@";
          };
        };
        mods = {
          BETTER_FABRIC_CONSOLE = {
            url = "https://cdn.modrinth.com/data/Y8o1j1Sf/versions/OexcFHtG/better-fabric-console-mc1.21.5-1.2.3.jar";
            sha512 = "0a5b0da9d6d3c78ed9af66d2bca3976889649942025aecf7f469bea500ce7914070569259332fefb3629b2eb478ee0cfbf85252aaec5d7969727c1668732e8f4";
          };
          C2ME = {
            url = "https://cdn.modrinth.com/data/VSNURh3q/versions/jrmtD6AF/c2me-fabric-mc1.21.5-0.3.3.0.0.jar";
            sha512 = "4d6a3efcef9aaec8b494f1ac5917c5230175d6485592243a45eb2ee263baf481ce07681b0fb5b65a4969cd08d4708e001a83b17949dad32a646a8ea26052a9f9";
          };
          FABRIC_API = {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/B41MB8lb/fabric-api-0.126.0%2B1.21.5.jar";
            sha512 = "24f83225bcd96a77c84dda5b47e26189bc2f690071453cdbe2e70e9ede41c99063507da2438d77e87efa8dedaef72c557c1a1f6a8e18ede9fb3a7aa608bbd596";
          };
          FABRIC_PROXY_LITE = {
            url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/AQhF7kvw/FabricProxy-Lite-2.9.0.jar";
            sha512 = "3044f36df7e83021210a7c318def18a95b5dbf5e3230bb72a3ddb42ebdda33f248c6d12efcee1240ff0c54600d68d147afa105d04ee37a90acb9409619c89848";
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
            url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/VWYoZjBF/lithium-fabric-0.16.2%2Bmc1.21.5.jar";
            sha512 = "09a68051504bb16069dd6af8901f2bbeadfd08ad5353d8bcc0c4784e814fb293d9197b4fb0a8393be1f2db003cd987a9e4b98391bbe18c50ae181dace20c2fa4";
          };
          NOISIUM = {
            url = "https://cdn.modrinth.com/data/KuNKN7d2/versions/sUh67T4Y/noisium-fabric-2.6.0%2Bmc1.21.5.jar";
            sha512 = "4471b6137de7e2109987df8fe62ac836741e68ba3c57303a0f2dc362c0ab8e7aca656d28046e250362316c1144396132a5531dfb12b5a664c68eb294991af938";
          };
          TAB_TPS = {
            url = "https://cdn.modrinth.com/data/cUhi3iB2/versions/HfAo5mkW/tabtps-fabric-mc1.21.5-1.3.27.jar";
            sha512 = "2b6ae4571ddc6dc34e607b813e8034213e0e70e2b49029b7ed18f1f3093aa017d082e866247ce554b9ae064a3a0a28cc4c51a69dae4067080768c0fb75b57674";
          };
          THREAD_TWEAK = {
            url = "https://cdn.modrinth.com/data/vSEH1ERy/versions/IvtlnXcT/threadtweak-fabric-0.1.7%2Bmc1.21.5.jar";
            sha512 = "aec7e39b478d47dc96ba12291fd048ed9253c39d27a0c25b8565b3cef08eb5117b4f6bf2453c3377d2de739de8ba0501c77b291b6f0fc82559f0f30514a9125a";
          };
        };
      };
    };
  };
}
