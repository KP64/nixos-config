{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./disko-config.nix
  ]
  ++ (with inputs; [
    catppuccin.nixosModules.default
    disko.nixosModules.default
    home-manager.nixosModules.default
    musnix.nixosModules.default
    nixos-facter-modules.nixosModules.facter
    sops-nix.nixosModules.default
  ]);
  facter.reportPath = ./facter.json;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
  }
  // (
    {
      kernelPackages = pkgs.linuxPackages_zen;
    }
    |> lib.optionalAttrs (!pkgs.stdenv.isAarch64)
    |> lib.mergeAttrs { tmp.cleanOnBoot = true; }
    # |> lib.mkDefault
  );

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      "users/kg/password".neededForUsers = true;
      "wireless.env" = { };
    };
  };

  security = {
    polkit.enable = true;
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };

  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  catppuccin = {
    enable = true;
    cache.enable = true;
    accent = "lavender";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };
  musnix = {
    enable = true;
    rtcqs.enable = true;
  };

  nixpkgs.config.cudaSupport = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia = {
      open = true;
      nvidiaPersistenced = true;
      powerManagement.enable = true;
    };
    nvidia-container-toolkit.enable = true;
  };

  networking = {
    nftables.enable = true;
    networkmanager = {
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
  };

  time.timeZone = "Europe/Berlin";

  # TODO: Topology

  services = {
    fwupd.enable = true;
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
  };

  programs = {
    ausweisapp = {
      enable = true;
      openFirewall = true;
    };
    gamemode.enable = true;
    hyprland.enable = true;
    localsend.enable = true;
    weylus = {
      enable = true;
      openFirewall = true;
      users = [ "kg" ];
    };
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
  };

  programs.steam = {
    enable = true;
    extest.enable = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };
}
