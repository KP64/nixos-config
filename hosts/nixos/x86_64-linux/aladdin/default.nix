{ config, rootPath, ... }:
{
  imports = [ ./disko-config.nix ];

  facter.reportPath = ./facter.json;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
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
    networking.enable = true;
    nvidia.enable = true;
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

  catppuccin = {
    enable = true;
    accent = "lavender";
    sddm.background = "${rootPath}/assets/wallpapers/cat-nix.png";
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

  virt = {
    docker.enable = true;
    # TODO: Borked
    # virtualbox.enable = true;
  };
}
