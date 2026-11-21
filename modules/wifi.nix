{ self, ... }: {
  # TODO: Disable compatibility mode in router for full WPA3 functionality
  #        -> Remove or Replace repeater
  den.aspects.wifi.nixos =
    { config, lib, ... }:
    let
      secretName = "HOME_WIFI_PASSWORD";
      envFile = "wireless.env";
    in
    {
      sops = {
        secrets.wifi-password = {
          sopsFile = "${self}/secrets/home-wifi.yaml";
          key = "password";
          restartUnits = [ config.systemd.services.wpa_supplicant.name ];
        };
        templates.${envFile} = {
          owner = config.users.users.wpa_supplicant.name;
          content = ''
            ${secretName}=${config.sops.placeholder.wifi-password}
          '';
        };
      };

      # TODO: Change from wpa_supplicant to iwd when https://github.com/NixOS/nixpkgs/pull/571920 is merged
      networking.wireless = {
        enable = true;
        secretsFile = config.sops.templates.${envFile}.path;
        networks =
          let
            network = "FRITZ!Box 4630 QX";
          in
          lib.genAttrs [ network "${network}-5GHz" ] (_: {
            pskRaw = "ext:${secretName}";
          });
      };
    };
}
