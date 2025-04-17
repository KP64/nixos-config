{ config, ... }:
{
  imports = [ ./disko-config.nix ];

  facter.reportPath = ./facter.json;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age = {
      keyFile = "/home/kg/.config/sops/age/keys.txt";
      sshKeyPaths = [ "/home/kg/.ssh/id_ed25519" ];
    };
    secrets = {
      "users/kg/password".neededForUsers = true;
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
    style.catppuccin.enable = true;
  };

  hardware = {
    audio.enable = true;
    bluetoothctl.enable = true;
    networking.enable = true;
    nvidia.enable = true;
  };

  networking.networkmanager.ensureProfiles = {
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

  time.timeZone = "Europe/Berlin";

  topology.self.interfaces.wlp6s0 =
    let
      inherit (config.lib) topology;
    in
    {
      network = "home";
      physicalConnections = [ (topology.mkConnectionRev "router" "wifi") ];
    };

  services = {
    blueman.enable = true;
    udisks2.enable = true;
  };

  programs = {
    hyprland.enable = true;
    gamemode.enable = true;
  };

  apps.obs.enable = true;

  desktop.login.sddm.enable = true;

  file-managers.thunar.enable = true;

  gaming.launchers.steam.enable = true;

  virt.docker.enable = true;
}
