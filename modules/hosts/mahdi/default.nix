toplevel@{ inputs, ... }:
{
  flake.modules.nixos.hosts-mahdi =
    { config, pkgs, ... }:
    {
      imports =
        (with inputs; [
          nixos-facter-modules.nixosModules.facter
          sops-nix.nixosModules.default
        ])
        ++ (with inputs; [
          disko.nixosModules.default
          self.diskoConfigurations.mahdi
        ])
        ++ (with toplevel.config.flake.modules.nixos; [
          catppuccin
          efi
          fonts
          nix
          ssh
          sudo

          users-kg
        ]);

      facter.reportPath = ./facter.json;
      system.stateVersion = "25.11";

      time.timeZone = "Europe/Berlin";
      console.keyMap = "de";
      services.xserver.xkb.layout = "de";

      boot.kernelPackages = pkgs.linuxPackages_zen;

      sops = {
        defaultSopsFile = ./secrets.yaml;
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        secrets = {
          "wireless.env" = { };
        };
      };

      # This service is the "only" way to
      # communicate with the TPM (v1.2) device
      services.tcsd.enable = true;

      users.users.root = {
        isSystemUser = true;
        hashedPasswordFile = config.sops.secrets."users/kg/password".path;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlAyglgR4yyhiIy0K4hzu0syefzRE/IsKkx+IskC7xF kg@aladdin"
        ];
      };

      # TODO: Use resolved for DNS resolution (DNSSEC!)
      #  - networking.networkmanager.dns = "systemd-resolved"
      networking = {
        domain = "holab.ipv64.de";
        networkmanager = {
          enable = true;
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
