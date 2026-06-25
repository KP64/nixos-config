{ self, ... }: {
  den.aspects.networking._.wifi.nixos = { config, ... }: {
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
      fallbackToWPA2 = false;
      scanOnLowSignal = false;
      networks."FRITZ!Box 4630 QX".pskRaw = "ext:HOME_WIFI_PASSWORD";
    };
  };
}
