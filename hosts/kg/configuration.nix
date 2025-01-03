{
  config,
  username,
  stateVersion,
  ...
}:

{
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

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

  file-managers = {
    broot.enable = true;
    thunar.enable = true;
    yazi.enable = true;
  };

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

    ricing = {
      defaults.enable = true;
      cava.enable = true;
      fetchers.enable = true;
    };

    terminals.kitty.enable = true;

    monitors = {
      btop.enable = true;
      bandwhich.enable = true;
    };
  };

  hardware = {
    audio.enable = true;
    bluetoothctl.enable = true;
    networking.enable = true;
    nvidia.enable = true;
  };

  desktop = {
    defaults.enable = true;

    eww.enable = true;

    rofi.enable = true;

    login.sddm.enable = true;

    hypr = {
      hypridle.enable = true;
      hyprlock.enable = true;
      hyprpanel.enable = true;
      hyprpaper.enable = true;
      hyprland = {
        enable = true;
        monitors = [
          {
            name = "DP-3";
            resolution = "highrr";
            vrr = 2;
            workspaces = [
              {
                id = 1;
                default = true;
              }
            ];
          }
          {
            name = "HDMI-A-1";
            x = 1920;
            y = 500;
            workspaces = [
              {
                id = 2;
                default = true;
              }
            ];
          }
        ];
      };
    };

    services = {
      blueman-app.enable = true;
      copyq.enable = true;
      ntwrk-mgr-app.enable = true;
      udiskie.enable = true;
    };
  };

  editors = {
    aseprite.enable = false;
    blender.enable = true;
    helix.enable = true;
    imhex.enable = true;
    vscode.enable = true;
    zed.enable = true;
  };

  apps = {
    defaults.enable = true;
    spicetify.enable = true;
    obs.enable = true;
    mpv.enable = true;
    thunderbird.enable = true;
    browsers = {
      firefox.enable = true;
      tor.enable = true;
    };
  };

  virt = {
    docker.enable = true;
    virtualbox.enable = true;
  };

  gaming = {
    defaults.enable = true;
    discord.enable = true;
    emulators.enable = true;
    heroic.enable = true;
    mangohud.enable = true;
    gamemode.enable = true;
    steam.enable = true;
  };

  networking = {
    hostName = username;

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
      };
    };
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age =
      let
        persistDir = "/persist/home/${username}";
      in
      {
        keyFile = "${persistDir}/.config/sops/age/keys.txt";
        sshKeyPaths = [ "${persistDir}/.ssh/id_ed25519" ];
      };
    secrets = {
      hashed_password.neededForUsers = true;
      "wireless.env" = { };
    };
  };

  topology.self.interfaces.wlp6s0 =
    let
      inherit (config.lib) topology;
    in
    {
      network = "home";
      physicalConnections = [ (topology.mkConnectionRev "router" "wifi") ];
    };

  services.ai = {
    open-webui.enable = true;
    ollama = {
      enable = true;
      acceleration = "cuda";
      models = [
        "llama3.2"
        "llama3.1:8b"
      ];
    };
  };

  time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;

  users.users.${username} = {
    hashedPasswordFile = config.sops.secrets.hashed_password.path;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "docker"
      "kvm"
      "libvirtd"
      "audio"
      "video"
      "tss"
    ];
  };
}
