toplevel@{ inputs, ... }:
{
  flake.modules.nixos.hosts-aladdin =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports =
        (with inputs; [
          nixos-facter-modules.nixosModules.facter
          sops-nix.nixosModules.default
        ])
        ++ (with toplevel.config.flake.modules.nixos; [
          audio
          catppuccin
          gaming
          hyprland
          nix
          nvidia
          sddm
          ssh
          sudo
          tpm

          users-kg
        ]);

      facter.reportPath = ./facter.json;

      sops = {
        defaultSopsFile = ./secrets.yaml;
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        secrets = {
          "wireless.env" = { };
        };
      };

      time.timeZone = "Europe/Berlin";

      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "nvidia-x11"
          "nvidia-settings"

          "steam"
          "steam-unwrapped"

          # Unfree packages added by home-manager user kg
          "cuda_cccl"
          "libcublas"
          "libcurand"
          "libcusparse"
          "libnvjitlink"
          "libcufft"
          "cudnn"
          "cuda_cudart"
          "cuda_nvcc"
          "cuda_nvrtc"
        ];

      # TODO: Move to home-manager per user basis
      fonts.packages = [
        pkgs.font-awesome
      ]
      ++ (with pkgs.nerd-fonts; [
        jetbrains-mono
        symbols-only
      ]);

      system.stateVersion = "25.11";

      boot.kernelPackages = pkgs.linuxPackages_zen;
      boot.tmp.cleanOnBoot = true;

      boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          editor = false;
        };
      };

      console.keyMap = "de";
      services.xserver.xkb.layout = "de";

      programs = {
        ausweisapp = {
          enable = true;
          openFirewall = true;
        };
        localsend.enable = true;
        weylus = {
          enable = true;
          openFirewall = true;
          # TODO: Is there a better way?
          # users = [ config.users.users.kg.name ];
        };
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
    };
}
