{
  config,
  pkgs,
  username,
  stateVersion,
  invisible,
  ...
}:

{
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
  ];

  environment.systemPackages = [ pkgs.openboard ];

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services = {
    thermald.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    thinkfan = {
      enable = true;
      smartSupport = true;
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system = {
    inherit stateVersion;
    boot.efi.enable = true;
    impermanence.enable = true;
    security = {
      uutils-coreutils.enable = true;
      polkit.enable = true;
      tpm.enable = true;
      sudo-rs.enable = true;
    };
    style.catppuccin.enable = true;
  };

  file-managers.enable = true;

  terminals.enable = true;

  cli = {
    enable = true;
    git.user = {
      name = "KP64";
      inherit (invisible) email;
    };
  };

  hardware = {
    audio.enable = true;
    bluetoothctl.enable = true;
    intel.enable = true;
    networking.enable = true;
  };

  desktop = {
    enable = true;
    hypr.hyprland.monitors = [
      {
        name = "eDP-1";
        resolution = "highrr";
        vrr = 2;
      }
    ];
  };

  editors = {
    helix.enable = true;
    vscode.enable = true;
  };

  browsers.firefox.enable = true;

  gaming = {
    discord.enable = true;
    steam.enable = true;
    emulators.enable = true;
  };

  apps = {
    misc.enable = true;
    mpv.enable = true;
    spicetify.enable = true;
    thunderbird.enable = true;
  };

  networking = {
    hostName = username;

    # TODO: Add WG Profiles
    networkmanager.ensureProfiles = {
      environmentFiles = [ config.sops.secrets."wireless.env".path ];
      profiles = {
        home-wifi = {
          connection = {
            id = "home-wifi";
            type = "wifi";
          };
          wifi.ssid = "$HOME_WIFI_SSID";
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$HOME_WIFI_PASSWORD";
          };
        };

        jw-wifi = {
          connection = {
            id = "jw-wifi";
            type = "wifi";
          };
          wifi.ssid = "$JW_WIFI_SSID";
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$JW_WIFI_PASSWORD";
          };
        };
      };
    };
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/persist/home/${username}/.ssh/id_ed25519" ];
    secrets = {
      hashed_password.neededForUsers = true;
      "wireless.env" = { };
    };
  };

  topology.self =
    let
      inherit (config.lib) topology;
    in
    {
      hardware = {
        info = "Lenovo Thinkpad Yoga 370";
        image = ../../topology/yoga370.png;
      };

      interfaces.wlp4s0 = {
        network = "home";
        physicalConnections = [ (topology.mkConnectionRev "router" "wifi") ];
      };
    };

  time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;

  users.users =
    let
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmnXKmHkmJFNQ5cll8rNmkQ0yU5l6MetqNz7BWMVlhG kg@kg"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAD+mYDOwD6lR89dpPCprEDTBIBNKgjzb6sqoGCHOYl7 kg@LapT"
      ];
    in
    {
      root.openssh.authorizedKeys = { inherit keys; };

      ${username} = {
        hashedPasswordFile = config.sops.secrets.hashed_password.path;
        openssh.authorizedKeys = { inherit keys; };
        extraGroups = [
          "networkmanager"
          "wheel"
          "input"
          "kvm"
          "libvirtd"
          "audio"
          "video"
          "tss"
        ];
      };
    };
}
