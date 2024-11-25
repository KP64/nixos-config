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

  hardware = {
    intel-gpu-tools.enable = true;
    graphics = {
      enable = true;
      extraPackages = [ pkgs.vpl-gpu-rt ];
    };
  };

  system = {
    inherit stateVersion;
    boot.efi.enable = true;
    impermanence.enable = true;
    security = {
      uutils-coreutils.enable = true;
      polkit.enable = true;
      tpm.enable = true;
      secure-boot.enable = false;
      sudo-rs.enable = true;
    };
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
    networking.enable = true;
  };

  desktop = {
    defaults.enable = true;

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

  networking.hostName = username;

  # sops = {
  #   defaultSopsFile = ./secrets.yaml;
  #   age = {
  #     keyFile = "/persist/home/${username}/.config/sops/age/keys.txt";
  #     sshKeyPaths = [ "/home/${username}/.ssh/id_ed25519" ];
  #   };
  #   secrets.hashed_password.neededForUsers = true;
  # };

  topology.self.interfaces.wlp4s0 =
    let
      inherit (config.lib) topology;
    in
    {
      network = "home";
      physicalConnections = [ (topology.mkConnectionRev "router" "wifi") ];
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

  users.users.${username} = {
    # hashedPasswordFile = config.sops.secrets.hashed_password.path;
    initialPassword = "12345";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAgE5a4Wn4S/to9Z3QbQSDMyCOG/NAOWYJDEvAy4OdFf kg@kg"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAD+mYDOwD6lR89dpPCprEDTBIBNKgjzb6sqoGCHOYl7 kg@LapT"
    ];
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
