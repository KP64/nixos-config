{
  lib,
  config,
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
    services.ssh.enable = true;
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

    ricing.fetchers.enable = true;

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

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    secrets = {
      hashed_password.neededForUsers = true;
      "wg/keys/client" = { };
      "wg/keys/server" = { };
      "wg/keys/preshared/lap" = { };
      "wg/keys/preshared/hon" = { };
    };
  };

  networking =
    let
      dnsPort = 53;
      port = 58008;
    in
    {
      hostName = username;

      # TODO: Move with wireguard to own module
      nat = {
        enable = true;
        # TODO: Enable IPv6
        enableIPv6 = false;
        externalInterface = "end0";
        # TODO: when moving to module get interfaces automatically through options.
        internalInterfaces = [ "wg0" ];
      };
      firewall = {
        allowedTCPPorts = [ dnsPort ];
        allowedUDPPorts = [
          dnsPort
          port
        ];
      };

      # TODO: rs as server and client at the same time?
      wg-quick.interfaces =
        let
          inherit (config.sops) secrets;
          ipv4tables = "${pkgs.iptables}/bin/iptables";
        in
        {
          wg0 = {
            autostart = true;
            address = [ "172.31.0.1/32" ];
            listenPort = port;
            privateKeyFile = secrets."wg/keys/server".path;

            postUp = ''
              ${ipv4tables} -A FORWARD -i wg0 -j ACCEPT
              ${ipv4tables} -t nat -A POSTROUTING -s 172.31.0.1/32 -o end0 -j MASQUERADE
            '';

            postDown = ''
              ${ipv4tables} -D FORWARD -i wg0 -j ACCEPT
              ${ipv4tables} -t nat -D POSTROUTING -s 172.31.0.1/32 -o end0 -j MASQUERADE
            '';

            # TODO: Increment automatically?
            # TODO: require presharedKeyFile and route it to secret path automatically
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
          # TODO: Mark external interfaces to diff with wich to include in firewall.
          wg1 = {
            autostart = false;
            address = [ "10.2.0.2/32" ];
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
    immich = {
      enable = true;
      host = "192.168.2.204";
      openFirewall = true;
      # ? Machine Learning is broken on aarch64
      machine-learning.enable = false;
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
      }
    ];

    networking.adguard = {
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
        "ubisoft"
        "whatsapp"
        "xbox_live"
        "youtube"
      ];
    };
  };

  users.users.${username} = {
    hashedPasswordFile = config.sops.secrets.hashed_password.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAprQ6/cB+MxEK5IorzJ1+/HoYqyc5ZItGG4HzYwTO3S karamalsadeh@hotmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAD+mYDOwD6lR89dpPCprEDTBIBNKgjzb6sqoGCHOYl7 kg@LapT"
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
}
