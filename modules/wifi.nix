{ self, ... }: {
  den.aspects.wifi = { lib, ... }: {
    settings.SSID = lib.mkOption {
      default = "FRITZ!Box 4630 QX-5GHz";
      type = lib.types.nonEmptyStr;
      example = "FRITZ!Box 4630 QX";
      description = "The SSID to connect to via Wifi";
    };

    nixos = { host, config, ... }: {
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

      networking.wireless = {
        enable = true;
        secretsFile = config.sops.templates."wireless.env".path;
        networks.${host.settings.wifi.SSID}.pskRaw = "ext:HOME_WIFI_PASSWORD";
      };
    };
  };
}
