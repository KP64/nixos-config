{
  config,
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

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  programs.sniffnet.enable = true;

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

  hardware = {
    audio.enable = true;
    bluetoothctl.enable = true;
    networking.enable = true;
    nvidia.enable = true;
  };

  cli.git.user = {
    name = "KP64";
    inherit (invisible) email;
  };

  apps.enable = true;

  virt.enable = true;

  desktop = {
    enable = true;
    hypr.hyprland.monitors = [
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
      models = [
        "llama3.2"
        "llama3.1:8b"
        "deepseek-r1:8b"
      ];
    };
  };

  time.timeZone = "Europe/Berlin";

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };

  users.users.${username} = {
    hashedPasswordFile = config.sops.secrets.hashed_password.path;
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
}
