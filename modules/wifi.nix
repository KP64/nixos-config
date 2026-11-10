{ self, ... }: {
  # TODO: Disable compatibility mode in router for full WPA3 functionality
  #        -> Remove or Replace repeater
  den.aspects.wifi.nixos = { config, ... }: {
    sops = {
      secrets.wifi-password = {
        sopsFile = "${self}/secrets/home-wifi.yaml";
        key = "password";
        restartUnits = [ config.systemd.services.wpa_supplicant.name ];
      };
      templates."wireless.env" = {
        owner = config.users.users.wpa_supplicant.name;
        content = ''
          HOME_WIFI_PASSWORD=${config.sops.placeholder.wifi-password}
        '';
      };
    };

    # TODO: Change from wpa_supplicant to iwd when https://github.com/NixOS/nixpkgs/pull/571920 is merged
    networking.wireless = {
      enable = true;
      secretsFile = config.sops.templates."wireless.env".path;
      networks = {
        "FRITZ!Box 4630 QX-5GHz".pskRaw = "ext:HOME_WIFI_PASSWORD";
        "FRITZ!Box 4630 QX".pskRaw = "ext:HOME_WIFI_PASSWORD";
      };
    };
  };
}
