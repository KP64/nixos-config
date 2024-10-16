{
  config,
  pkgs,
  username,
  stateVersion,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  programs.noisetorch.enable = true;

  system = {
    inherit stateVersion;
    boot.efi.enable = true;
    security = {
      uutils-coreutils.enable = true;
      polkit.enable = true;
      tpm.enable = true;
      secure-boot.enable = true;
      sudo-rs.enable = true;
    };
    fonts.extraFonts = with pkgs; [
      cascadia-code
      iosevka
      siji
      weather-icons
    ];
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
    aseprite.enable = true;
    blender.enable = true;
    helix.enable = true;
    imhex.enable = true;
    vscode.enable = true;
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

  virt.docker.enable = true;

  gaming = {
    defaults.enable = true;
    discord.enable = true;
    emulators.enable = true;
    heroic.enable = true;
    mangohud.enable = true;
    gamemode.enable = true;
    steam.enable = true;
  };

  networking.hostName = username;

  topology =
    let
      inherit (config.lib.topology)
        mkRouter
        mkConnection
        mkConnectionRev
        mkInternet
        ;
    in
    {
      self.interfaces.wlan.physicalConnections = [ (mkConnectionRev "router" "wlan") ];
      nodes = {
        internet = mkInternet {
          connections = mkConnection "router" "wan1";
        };
        router = mkRouter "Router" {
          info = "Speedport Smart 4";
          # wan1 is the external DSL connection
          interfaceGroups = [
            [ "wlan" ]
            [ "wan1" ]
            [
              "eth1"
              "eth2"
              "eth3"
              "eth4"
            ]
          ];
        };
      };
    };

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

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

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    secrets.hashed_password.neededForUsers = true;
  };

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
