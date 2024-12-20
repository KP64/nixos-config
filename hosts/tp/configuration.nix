{
  config,
  pkgs,
  username,
  stateVersion,
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
          governor = "powersave";
          turbo = "never";
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
    services.ssh.enable = true;
    style.catppuccin.enable = true;
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

    file-managers = {
      yazi.enable = true;
      broot.enable = true;
    };

    ricing = {
      defaults.enable = true;
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
    intel.enable = true;
    networking.enable = true;
  };

  desktop = {
    defaults.enable = true;

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
            name = "eDP-1";
            resolution = "highrr";
            vrr = 2;
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
    helix.enable = true;
    vscode.enable = true;
  };

  apps = {
    defaults.enable = true;
    spicetify.enable = true;
    mpv.enable = true;
    thunderbird.enable = true;
    browsers.firefox.enable = true;
  };

  gaming.discord.enable = true;

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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICHYe+2EqTg5Uh0/PZXhnuznFE84uiEzBtgd8qz9sUWS ed25519"
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
          "docker"
          "kvm"
          "libvirtd"
          "audio"
          "video"
          "tss"
        ];
      };
    };
}
