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

  # FIXME: These Mods only work on 1.21.1 Fabric.
  # TODO: Write a script that gets the right version
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
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  # TODO: Overhaul Options
  # Ability to:
  #   - add mods
  options.services.gaming.minecraft = {
    servers = lib.mkOption {
      default = [ ];
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              readOnly = true;
              type = lib.types.strMatching "([a-zA-Z0-9])+";
              description = "The name of the Server";
              example = "My Cool Server";
            };

            enable = lib.mkEnableOption "Enable the Server";

            version = lib.mkOption {
              readOnly = true;
              type = lib.types.strMatching "[0-9]\\.[0-9]{1,2}(\\.[0-9])?";
              description = "The version of the Server";
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
              type = lib.types.listOf lib.types.str;
            };

            symlinks = lib.mkOption {
              default = { };
              type = lib.types.attrs;
            };
          };
        }
      );
    };
  };
  config = lib.mkIf (cfg.servers != [ ]) {
    services.minecraft-servers = {
      enable = true;
      eula = true;

      servers = builtins.listToAttrs (
        map (
          s: let
           ver = builtins.replaceStrings [ "." ] [ "_" ] s.version; 
          in
          lib.nameValuePair s.name {
            inherit (s) enable serverProperties;
            symlinks = s.symlinks // {
              inherit mods;
            };
            openFirewall = s.enable;
            jvmOpts = builtins.concatStringsSep " " ((defaultOpts s.ram) ++ s.jvmOpts);
            package = pkgs.minecraftServers."fabric-${ver}";
          }
        ) cfg.servers
      );
    };
  };
}
