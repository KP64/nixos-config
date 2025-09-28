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
        ++ (with inputs; [
          disko.nixosModules.default
          self.diskoConfigurations.aladdin
        ])
        ++ (with toplevel.config.flake.modules.nixos; [
          audio
          catppuccin
          desktop
          efi
          gaming
          nix
          nvidia
          ssh
          sudo
          tpm

          users-kg
        ]);

      # TODO: Add Bluetooth module
      facter.reportPath = ./facter.json;

      system.stateVersion = "25.11";
      time.timeZone = "Europe/Berlin";
      console.keyMap = "de";
      services.xserver.xkb.layout = "de";

      boot.kernelPackages = pkgs.linuxPackages_zen;

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

      sops = {
        defaultSopsFile = ./secrets.yaml;
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };

      users.users.root = {
        isSystemUser = true;
        hashedPasswordFile = config.sops.secrets."users/kg/password".path;
      };

      programs = {
        ausweisapp = {
          enable = true;
          openFirewall = true;
        };
        localsend.enable = true;
        weylus = {
          enable = true;
          openFirewall = true;
          users = map (user: user.name) (with config.users.users; [ kg ]);
        };
      };
    };
}
