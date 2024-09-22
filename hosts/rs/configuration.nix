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

  services = {
    openssh.enable = true;
    minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      # TODO: Factor out minecraft servers to own customizable module with sensible defaults
      # TODO: Find a way to improve these abominations
      servers.cool-server1 = {
        enable = false;
        package = pkgs.fabricServers.fabric-1_21_1;
        serverProperties = {
          server-port = 42069;
          max-players = 2;
          difficulty = "hard";
          motd = "NixOS MC Server";
          simulation-distance = 12;
          view-distance = 12;
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
    users = {
      root.initialPassword = "root";
      ${username} = {
        isNormalUser = true;
        description = username;
        initialPassword = "12345";
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
  };
}
