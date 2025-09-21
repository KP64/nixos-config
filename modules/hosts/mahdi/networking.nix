toplevel: {
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      imports = [ toplevel.config.flake.modules.nixos.dns ];

      sops.secrets."wireless.env" = { };

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
