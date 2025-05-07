{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.services.gaming.minecraft;

  defaultOpts =
    ram:
    let
      r = toString ram;
    in
    [
      "-Xms${r}G"
      "-Xmx${r}G"
      "-Dusing.aikars.flags=https://mcflags.emc.gs"
      "-Daikars.new.flags=true"
    ]
    ++ (map (opt: "-XX:${opt}") [
      "+ParallelRefProcEnabled"
      "MaxGCPauseMillis=200"
      "+UnlockExperimentalVMOptions"
      "+DisableExplicitGC"
      "+AlwaysPreTouch"
      "G1NewSizePercent=30"
      "G1MaxNewSizePercent=40"
      "G1HeapRegionSize=8M"
      "G1ReservePercent=20"
      "G1HeapWastePercent=5"
      "G1MixedGCCountTarget=4"
      "InitiatingHeapOccupancyPercent=15"
      "G1MixedGCLiveThresholdPercent=90"
      "G1RSetUpdatingPauseTimePercent=5"
      "SurvivorRatio=32"
      "+PerfDisableSharedMem"
      "MaxTenuringThreshold=1"
    ]);
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  options.services.gaming.minecraft.servers = lib.mkOption {
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Server" // {
            default = true;
          };

          openFirewall = lib.mkEnableOption "Server Firewall";

          version = lib.mkOption {
            readOnly = true;
            type = lib.types.strMatching "[0-9]\\.[0-9]{1,2}(\\.[0-9])?";
            description = "The version of the Server";
            example = "1.21.1";
          };

          ram = lib.mkOption {
            readOnly = true;
            type = lib.types.ints.positive;
            description = "The amount of ram to allocate in GB";
            example = 4;
          };

          serverProperties = lib.mkOption {
            default = { };
            type = lib.types.attrs;
            example = {
              server-port = 25565;
              max-players = 16;
              difficulty = "hard";
              motd = "A NixOS MC Server";
              simulation-distance = 16;
              view-distance = 16;
            };
          };

          jvmOpts = lib.mkOption {
            default = [ ];
            type = with lib.types; listOf nonEmptyStr;
            description = "Extra Arguments to pass to the JVM.";
          };

          mods = lib.mkOption {
            default = [ ];
            description = "The mods to load with the server.";
            type = lib.types.attrsOf (
              lib.types.submodule {
                options = {
                  url = lib.mkOption {
                    readOnly = true;
                    type = lib.types.nonEmptyStr;
                    description = "The url of the mod .jar file.";
                  };
                  sha512 = lib.mkOption {
                    readOnly = true;
                    type = lib.types.nonEmptyStr;
                    description = "The sha of the .jar file.";
                  };
                };
              }
            );
          };

          symlinks = lib.mkOption {
            default = { };
            type = lib.types.attrs;
          };
        };
      }
    );
  };
  config = lib.mkIf (cfg.servers != { }) {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    services = {
      traefik.dynamicConfigOptions.http =
        cfg.servers
        |> lib.filterAttrs (_: s: s.enable)
        |> builtins.mapAttrs (
          name: s:
          let
            inherit (s.serverProperties) server-port;
          in
          {
            routers.${name} = {
              rule = "Host(`${name}.${config.networking.domain}`)";
              service = name;
            };
            services.${name}.loadBalancer.servers = [ { url = "http://localhost:${toString server-port}"; } ];
          }
        )
        |> builtins.attrValues
        |> lib.mergeAttrsList;

      minecraft-servers = {
        enable = true;
        eula = true;
        servers =
          cfg.servers
          |> lib.mapAttrs (
            _: s:
            let
              ver = builtins.replaceStrings [ "." ] [ "_" ] s.version;
            in
            {
              inherit (s) enable serverProperties openFirewall;
              symlinks = lib.recursiveUpdate s.symlinks {
                mods = s.mods |> builtins.attrValues |> map pkgs.fetchurl |> pkgs.linkFarmFromDrvs "mods";
              };
              jvmOpts = builtins.concatStringsSep " " ((defaultOpts s.ram) ++ s.jvmOpts);
              package = pkgs.minecraftServers."fabric-${ver}";
            }
          );
      };
    };
  };
}
