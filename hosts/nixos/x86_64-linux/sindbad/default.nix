{ config, rootPath, ... }:
{
  imports = [ ./disko-config.nix ];

  facter.reportPath = ./facter.json;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age = {
      keyFile = "/home/tp/.config/sops/age/keys.txt";
      sshKeyPaths = [ "/home/tp/.ssh/id_ed25519.pub" ];
    };
    secrets = {
      "users/tp/password".neededForUsers = true;
      "wireless.env" = { };
    };
  };

  security.polkit.enable = true;

  system = {
    stateVersion = "24.11";
    boot.efi.enable = true;
    security = {
      tpm.enable = true;
      sudo-rs.enable = true;
    };
    services.ssh.enable = true;
  };

  hardware = {
    audio.enable = true;
    bluetoothctl.enable = true;
    intel.enable = true;
    networking.enable = true;
  };

  networking.networkmanager = {
    wifi.powersave = true;
    ensureProfiles = {
      environmentFiles = [ config.sops.secrets."wireless.env".path ];
      profiles.home-wifi = {
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

  time.timeZone = "Europe/Berlin";

  topology.self =
    let
      inherit (config.lib) topology;
    in
    {
      hardware = {
        info = "Lenovo Thinkpad Yoga 370";
        image = "${rootPath}/topology/yoga370.png";
      };

      interfaces.wlp4s0 = {
        network = "home";
        physicalConnections = [ (topology.mkConnectionRev "router" "wifi") ];
      };
    };

  catppuccin = {
    enable = true;
    accent = "lavender";
    sddm.background = "${rootPath}/assets/wallpapers/cat-nix.png";
  };

  services = {
    blueman.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    thermald.enable = true;
    auto-cpufreq = {
      enable = true;
      settings =
        let
          turbo = "auto";
        in
        {
          battery = {
            governor = "powersave";
            inherit turbo;
          };
          charger = {
            governor = "performance";
            inherit turbo;
          };
        };
    };
    thinkfan = {
      enable = true;
      smartSupport = true;
    };
  };

  programs = {
    hyprland.enable = true;
    gamemode.enable = true;
  };

  desktop.login.sddm.enable = true;

  file-managers.thunar.enable = true;

  gaming.launchers.steam.enable = true;
}
