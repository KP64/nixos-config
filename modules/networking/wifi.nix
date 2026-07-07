{ self, ... }: {
  den.aspects.networking._.wifi.nixos = { config, lib, ... }: {
    options.wifiSSID = lib.mkOption {
      default = "FRITZ!Box 4630 QX-5GHz";
      type = lib.types.nonEmptyStr;
    };

    config = {
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
        scanOnLowSignal = false;
        networks.${config.wifiSSID}.pskRaw = "ext:HOME_WIFI_PASSWORD";
      };
    };
  };
}
