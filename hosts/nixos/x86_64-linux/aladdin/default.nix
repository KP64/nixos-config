{ config, pkgs, ... }:
{
  imports = [ ./disko-config.nix ];

  facter.reportPath = ./facter.json;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      "users/kg/password".neededForUsers = true;
      "wireless.env" = { };
    };
  };

  security.polkit.enable = true;

  system = {
    stateVersion = "25.11";
    boot.efi.enable = true;
    security = {
      tpm.enable = true;
      sudo-rs.enable = true;
    };
    ssh.enable = true;
    style.catppuccin.enable = true;
  };

  hardware = {
    audio.enable = true;
    bluetoothctl.enable = true;
    nvidia.enable = true;
  };

  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openvpn ];
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

  topology.self.interfaces.wlp6s0 =
    let
      inherit (config.lib) topology;
    in
    {
      network = "home";
      physicalConnections = [ (topology.mkConnectionRev "router" "wifi") ];
    };

  services = {
    ollama = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
      loadModels =
        let
          toModel = name: params: map (p: "${name}:${toString p}b") params;
        in
        [
          "llama3.1:8b"
          "llava:7b"
          "mistral:7b"
        ]
        ++ toModel "llama3.2" [
          1
          3
        ]
        ++ toModel "deepseek-r1" [
          "1.5"
          7
          8
        ]
        ++ toModel "qwen3" [
          "0.6"
          "1.7"
          4
          8
        ]
        ++ toModel "gemma3" [
          1
          4
        ];
    };
    blueman.enable = true;
    udisks2.enable = true;
  };

  programs = {
    ausweisapp = {
      enable = true;
      openFirewall = true;
    };
    bandwhich.enable = true;
    gamemode.enable = true;
    hyprland.enable = true;
    localsend.enable = true;
    sniffnet.enable = true;
    trippy.enable = true;
    weylus.enable = true;
  };

  apps.obs.enable = true;

  desktop.login.sddm.enable = true;

  file-managers.thunar.enable = true;

  gaming.launchers.steam.enable = true;

  virt.docker.enable = true;
}
