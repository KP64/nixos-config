{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
# TODO: Script to auto update Mods
let
  cfg = config.services.gaming.minecraft;

  defaultOpts =
    (map (opt: "-D${opt}") [
      "using.aikars.flags=https://mcflags.emc.gs"
      "aikars.new.flags=true"
    ])
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

  options.services.gaming.minecraft = {
    environmentFile = lib.mkOption {
      default = null;
      type = with lib.types; nullOr path;
      description = "Env File";
    };
    servers = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "Server" // {
              default = true;
            };

            openFirewall = lib.mkEnableOption "Server Firewall";

            type = lib.mkOption {
              readOnly = true;
              type = lib.types.enum [
                "vanilla"
                "fabric"
                "quilt"
                "paper"
                "velocity"
              ];
              description = "The type of Server";
              example = "fabric";
            };

            version = lib.mkOption {
              readOnly = true;
              type = with lib.types; nullOr (strMatching "[0-9]\\.[0-9]{1,2}(\\.[0-9])?");
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
              type = with lib.types; attrsOf anything;
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
              default = defaultOpts;
              type = with lib.types; listOf nonEmptyStr;
              description = "Extra Arguments to pass to the JVM.";
            };

            mods = lib.mkOption {
              default = { };
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
              type = with lib.types; attrsOf anything;
            };

            files = lib.mkOption {
              default = { };
              type = with lib.types; attrsOf anything;
            };
          };
        }
      );
    };
  };
  config = lib.mkIf (cfg.servers != { }) {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      inherit (cfg) environmentFile;
      servers =
        cfg.servers
        |> lib.mapAttrs (
          _: s:
          let
            ver = builtins.replaceStrings [ "." ] [ "_" ] s.version;
            package =
              if (s.type == "velocity") then pkgs.velocity-server else pkgs.minecraftServers."${s.type}-${ver}";
          in
          {
            inherit (s)
              enable
              serverProperties
              openFirewall
              files
              ;
            symlinks = lib.recursiveUpdate s.symlinks {
              mods = s.mods |> builtins.attrValues |> map pkgs.fetchurl |> pkgs.linkFarmFromDrvs "mods";
            };
            jvmOpts =
              map (mode: "-Xm${mode}${toString s.ram}G") [
                "s"
                "x"
              ]
              ++ s.jvmOpts;
            inherit package;
          }
          // (lib.optionalAttrs (s.type == "velocity") { stopCommand = "end"; })
        );
    };
  };
}
