{
  config,
  pkgs,
  username,
  invisible,
  stateVersion,
  ...
}:
{
  system = {
    inherit stateVersion;
    security = {
      uutils.enable = true;
      polkit.enable = true;
      sudo-rs.enable = true;
    };
    services.ssh.enable = true;
    style.stylix.enable = true;
  };

  file-managers.yazi.enable = false;

  editors.helix.enable = true;

  cli = {
    enable = true;

    monitors.btop.enable = true;

    ricing.cava.enable = false;

    git.user = {
      name = "KP64";
      inherit (invisible) email;
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

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/home/rs/.ssh/id_ed25519" ];
    secrets = {
      hashed_password.neededForUsers = true;
      "wg/keys/client" = { };
      "wg/keys/server" = { };
      "wg/keys/preshared/lap" = { };
      "wg/keys/preshared/hon" = { };
    };
  };

  networking = {
    hostName = username;
    domain = "nix-pi.ipv64.de";
    firewall.allowPing = false;
  };

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

  virt.enable = true;

  time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;

  topology.self =
    let
      inherit (config.lib) topology;
    in
    {
      hardware = {
        info = "Raspberry Pi 400";
        image = ../../topology/rpi_400.png;
      };
      interfaces.end0 = {
        network = "home";
        physicalConnections = [ (topology.mkConnectionRev "router" "eth1") ];
      };
    };

  services = {
    security = {
      acme = {
        enable = true;
        inherit (invisible) email;
      };
      vaultwarden.enable = true;
    };

    media = {
      dumb.enable = true;
      invidious.enable = true;
      neuters.enable = true;
      redlib.enable = true;
      stirling-pdf.enable = true;
    };

    misc = {
      atuin.enable = true;
      firefox-sync.enable = true;
      forgejo.enable = true;
      glance = {
        enable = true;
        inherit (invisible.glance) location;
      };
      languagetool.enable = true;
      searxng.enable = true;
    };

    gaming.minecraft.servers = [
      {
        name = "myServer";
        enable = false;
        version = "1.21.1";
        ram = 2;
        serverProperties = {
          server-port = 42069;
          max-players = 2;
          difficulty = "hard";
          simulation-distance = 8;
          view-distance = 8;
        };
        symlinks.mods = pkgs.linkFarmFromDrvs "mods" [
          (pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/VSNURh3q/versions/AHlC1pea/c2me-fabric-mc1.21.1-0.3.0%2Balpha.0.212.jar";
            sha512 = "a1977f3bb02a793677db0b0e20494af4bd648efd3b7e83d0c1ef3f14e7fdc0c4d3a9561b841fde97a123b87123275ce3c213bf414f91bc1393f26c95a70f0536";
          })
          (pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/qKPgBeHl/fabric-api-0.104.0%2B1.21.1.jar";
            sha512 = "0773f45d364b506b4e5b024aa8f1d498900fcf0a020d2025154e163e50a0eeee1b8296bf29c21df5ced42126ed46635e5ed094df25796ec552eb76399438e7e7";
          })
          (pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/uXXizFIs/versions/wmIZ4wP4/ferritecore-7.0.0-fabric.jar";
            sha512 = "0f2f9b5aebd71ef3064fc94df964296ac6ee8ea12221098b9df037bdcaaca7bccd473c981795f4d57ff3d49da3ef81f13a42566880b9f11dc64645e9c8ad5d4f";
          })
          (pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/Acz3ttTp/krypton-0.2.8.jar";
            sha512 = "5f8cf96c79bfd4d893f1d70da582e62026bed36af49a7fa7b1e00fb6efb28d9ad6a1eec147020496b4fe38693d33fe6bfcd1eebbd93475612ee44290c2483784";
          })
          (pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/9x0igjLz/lithium-fabric-mc1.21.1-0.13.1.jar";
            sha512 = "4250a630d43492da35c4c197ae43082186938fdcb42bafcb6ccad925b79f583abdfdc17ce792c6c6686883f7f109219baecb4906a65d524026d4e288bfbaf146";
          })
          (pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/nmDcB62a/versions/T1ftCUJv/modernfix-fabric-5.19.3%2Bmc1.21.1.jar";
            sha512 = "36b4fa178e73b7eef5f42df619e67fe71307fafce8b1582acb11c36ad6792fafe88870d74e178898824ede405bd0873a8b00460f6507bdf87be9cfb6353edc7d";
          })
          (pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/KuNKN7d2/versions/4sGQgiu2/noisium-fabric-2.3.0%2Bmc1.21-1.21.1.jar";
            sha512 = "606ba78cf7f30d99e417c96aa042f600c1b626ed9c783919496d139de650013f1434fcf93545782e3889660322837ce6e85530d9e1a5cc20f9ad161357ede43e";
          })
          (pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/cUhi3iB2/versions/XxA9k8Fb/tabtps-fabric-mc1.21.1-1.3.25.jar";
            sha512 = "81e4cb760be4b8cd25546f0d30a7a99d22aa05f71adef9a4a8e8ef0c95cf7f2ce79d004d12b4b8f061a73e675791a7723ae1d58e51caf70a0d64c6e60102eaa0";
          })
        ];
      }
    ];

    networking = {
      i2p.enable = true;
      tor.enable = true;
      traefik.enable = true;

      wireguard =
        let
          inherit (config.sops) secrets;
        in
        {
          serverInterfaces.home = {
            listenPort = 58008;
            address.ipv4 = [ "172.31.0.1/32" ];
            privateKeyFile = secrets."wg/keys/server".path;
            peers = [
              {
                publicKey = "lWc5hzembujk45Zxnhjcx/vE2b6sZLaagGdkMgpZs0o=";
                allowedIPs = [ "172.31.0.2/32" ];
                presharedKeyFile = secrets."wg/keys/preshared/lap".path;
              }
              {
                publicKey = "8Ms2xhDzF3xlAqe88FEKtGJWjZ7TPtvLX+yhM6ZL6m4=";
                allowedIPs = [ "172.31.0.3/32" ];
                presharedKeyFile = secrets."wg/keys/preshared/hon".path;
              }
            ];
          };

          clientInterfaces.proton = {
            autostart = false;
            address.ipv4 = [ "10.2.0.2/32" ];
            dns = [ "10.2.0.1" ];
            privateKeyFile = secrets."wg/keys/client".path;
            peers = [
              {
                publicKey = "GqrhIyCiFfxq4hRI46+//Qtevp2D+gqzAIZrMAL//XM=";
                allowedIPs = [ "0.0.0.0/0" ];
                endpoint = "185.177.124.219:51820";
              }
            ];
          };
        };

      adguard = {
        enable = true;
        users = [
          {
            name = "ka64";
            password = "$2a$10$47XJ6KSFE4uXqACmYQQDaeDA4u6PVbCe8qD3xkcxel8TpwWBApawe";
          }
        ];
        rewrites = [
          {
            domain = "pi.local";
            answer = "192.168.2.204";
          }
        ];
        allowedServices = [
          "cloudflare"
          "discord"
          "ebay"
          "epic_games"
          "facebook"
          "minecraft"
          "nvidia"
          "reddit"
          "samsung_tv_plus"
          "signal"
          "spotify"
          "steam"
          "telegram"
          "tiktok"
          "twitch"
          "whatsapp"
          "youtube"
        ];
      };
    };
  };

  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwKX/O745ddCdc78VI/1c9weFT3+DAJNc8nYdVP1xji kg@kg"
    ];

    ${username} = {
      hashedPasswordFile = config.sops.secrets.hashed_password.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwKX/O745ddCdc78VI/1c9weFT3+DAJNc8nYdVP1xji kg@kg"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAD+mYDOwD6lR89dpPCprEDTBIBNKgjzb6sqoGCHOYl7 kg@LapT"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFqboCBFR7zCUKnUoIIXbYh42muPCKNXZ+g6cp/KXQaX tp@tp"
      ];
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "kvm"
        "libvirtd"
        "audio"
        "video"
        "tss"
        "multimedia"
      ];
    };
  };
}
